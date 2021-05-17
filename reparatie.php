<?php   
  // HTML/CSS door: Marco Schattevoet (517538) 
parse_str($_SERVER['QUERY_STRING']);
include 'includes/header.php';

if (!$admin){
    if(!isInWorkshopTeam($_SESSION["WerknemerID"])){
      header('Location: index.php');
      exit;
    }
  }


?>  

  
  
  <div class="ui grid">
    
    <div class="four wide column">
    
    <?php
    if(isset($fietsnummer)){
    $vervangdeOnderdelen = getVervangdeOnderdelen($fietsnummer);
    ?>
    <h3>Onderdelen vervangen:</h3>  
    <?php
    foreach($vervangdeOnderdelen as $row){
      echo getOnderdeelNaam($row['ONDERDEELID']);
      echo ' ';
      echo $row['REPARATIE_DATUM'];
      echo '<br>';
      
      }
    } ?>
    </div>
    
    <div class="five wide column">
      <h1>Reparatie</h1>
      <?php 
      if(isset($Succes)){ 
          if($Succes == 1){
            toonSucces("De fiets wordt nu door u gerepareerd.");      
        } else if($Succes == 2){
            toonSucces("De fiets is nu terug in queue");
        } else if($Succes == 3){
            toonSucces("De fiets is nu gerepareerd en uit de queue geplaatst");
        }
      }
      ?>
     <h3> Workshop: </h3>
     <select class="ui search dropdown" id="search-select" name="Workshop" onChange="window.document.location.href= 'reparatie.php?Workshop=' + this.options[this.selectedIndex].value;">
      <option></option>
      <?php 
      $werkplaatsen = getWorkshops();
      
      foreach($werkplaatsen as $row){
        echo "<option value='" . $row["WORKSHOPID"] . "' ";
        if(isset($Workshop) && $Workshop ==  $row["WORKSHOPID"]){
          echo "selected"; 
        }
        echo ">Workshop " . $row["WORKSHOPID"] . "</option>";
        
      }
      ?>
    </select> 
    
<?php
if(isset($Workshop)){
 ?> 
 <div class="ui accordion">
 
  <div class="title">
    <i class="dropdown icon"></i>
    Reparaties Nodig:
  </div>
  <div class="content">
    <table class="ui inverted red celled unstackable table">
      <thead>
        <tr>
          <th>Fietsnummer</th>
          <th>Volgnummer</th>
          <th>Wordt gerepareerd</th>
        </tr>
      </thead>
      <tbody>
        <?php toonReparatieQueue($Workshop); ?>
      </tbody>
    </table>
    <br>
  </div>
</div>

<?php } 

if(isset($_POST['Fietsnummer']) && isset($Workshop)){
  if(is_numeric($_POST['Fietsnummer'])){
    if(isset($_POST['WordtRepareren'])){
        if(wordRepareren($_POST['Fietsnummer'])){
          header('Location: reparatie.php?Workshop='.$Workshop . '&fietsnummer='.$fietsnummer . '&Succes=1');
          exit;  
        } 
    } else if(checkOnderdelen($_POST['Dropdown'])){
      if(isset($_POST['queue'])){
        if(!empty($_POST['Dropdown'][0])){
          insertReparatie($Workshop,$_POST['Fietsnummer'], $_POST['Dropdown'], $_SESSION["WerknemerID"]);
          }
          if(terugInQueue($_POST['Fietsnummer'], $_POST['Beschrijving'])){
            header('Location: reparatie.php?Workshop='.$Workshop . '&fietsnummer='.$fietsnummer . '&Succes=2');
            exit;
          }      
      } else {
        if(!empty($_POST['Dropdown'][0])){ 
          insertReparatie($Workshop,$_POST['Fietsnummer'], $_POST['Dropdown'], $_SESSION["WerknemerID"]);
          }       
          if(fietsNaarOutqueue($_POST['Fietsnummer'], $Workshop)){
            header('Location: reparatie.php?Workshop='.$Workshop . '&fietsnummer='.$fietsnummer . '&Succes=3');
            exit;
            }
      }
    } else {
     toonError2("Een van de onderdelen bestaat niet.");
    }
    } else { toonError2("Fietsnummer moet een nummer zijn.");}                     
}

?>


<form action="" method="post">

  <h3>Fietsnummer:</h3>
  <div class="ui form">
   <div class="field">		
     <input type="text" name="Fietsnummer" <?php if(isset($fietsnummer)){echo 'value="'.$fietsnummer.'"';}?>/>
   </div>
 </div>
 <br>
 <input class="ui large teal submit button" type="submit" class="button" name="WordtRepareren" value="Repareren" />
 <p>Gebruik deze knop om andere werknemers te laten weten dat de fiets al gerepareerd wordt.
 <h3> Gebruikte onderdelen: </h3>
 <table class="ui celled unstackable table">
  <div class="container1">
    <button class="add_form_field">Nieuw onderdeel &nbsp; <span style="font-size:16px; font-weight:bold;">+ </span></button>
    <div id="Onderdelen">
      <select class="ui search dropdown" id="search-select" name="Dropdown[]">
        <option value="">Onderdeel</option>
        <?php 
        $onderdelen = getAlleOnderdelen();
        
        foreach($onderdelen as $row){
          if( isset($Workshop) && checkInventarisVanWorkshop($Workshop, $row['ONDERDEELID'])){
          echo "<option value=" . $row['ONDERDEELID'] . ">" . $row['NAAM'] . "</option>";
          } else if (isset($Team)) {
          echo "<option value=" . $row['ONDERDEELID'] . ">" . $row['NAAM'] . "</option>";
          }      
        }
        ?>
      </select>
      <a href="#" class="delete">Delete</a>
    </div>
  </div>
</table>

<?php
if(isset($fietsnummer)){ 
  ?>
  <h3>Beschrijving van Team:</h3>
  <div class="field">
    <textarea rows="5" cols="50" name="Beschrijving"><?php
    echo getBeschrijvingVanQueue($fietsnummer);
    ?></textarea>
    
  </div>
  <?php } ?>
  <br>
  <input class="ui large teal submit button" type="submit" class="button" name="Reparatie" value="Voltooi">
  <?php
  if(isset($Workshop)){
   ?> 
   <input class="ui large teal submit button" type="submit" class="button" name="queue" value="Terug in queue">
   <?php
 }
 ?>
</form>
  
  </div>
  <div class="five wide column">
  </div> 
<br>
<div class="three wide column"></div>


</div>

<script> 
  $('.ui.accordion')
  .accordion()
  ;
</script>

<script>
  $(document).ready(function() {
    var max_fields      = 99;
    var wrapper         = $(".container1");
    var add_button      = $(".add_form_field");
    var opties          = document.getElementById("Onderdelen");
    var x = 1;
    $(add_button).click(function(e){
      e.preventDefault();
      if(x < max_fields){
        x++;
            $(wrapper).append("<div>" + opties.innerHTML + "</div>"); //add input box
          }
          else
          {
            alert('You Reached the limits')
          }
        });
    
    $(wrapper).on("click",".delete", function(e){
      e.preventDefault(); $(this).parent('div').remove(); x--;
    })
  });
</script>

<?php   
include 'includes/footer.php';
?>