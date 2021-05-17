<?php   
  // HTML/CSS door: Marco Schattevoet (517538) 
	parse_str($_SERVER['QUERY_STRING']);
  include 'includes/header.php';

  if (!$admin){
    if(!isInTeam($_SESSION["WerknemerID"])){
      header('Location: index.php');
      exit;
    }
  }

?>
 
<div class="ui text container">

  <h1>Fietsen</h1>
  <h2>Inspectie nodig:</h2>

  <table class="ui celled unstackable table">
    <thead>
      <tr>
        <th>Fietsnummer</th>
        <th>Arrondissements</th>
        <th>Stationnummer</th>
        <th>Fietspost</th>
      </tr>
    </thead>
    <tbody>
      <?php //toonFietsen();
      $fietsen = getFietsenMoetGechecktworden();
      $aantal = 0;
    if(!isset($nummer)){
     $nummer = 0;
    }
    
    foreach($fietsen as $row){
    $aantal++;
      if($aantal <= $nummer){
    continue;
    }
      if($aantal > $nummer + 10){
      break;
      }
      echo '<tr>';
      echo '<td>'.$row["FIETSID"].'</td>';
      echo '<td>'.$row["ARRONDISSEMENT"].'</td>';
      echo '<td>'.$row["STATIONNUMMER"].'</td>';
      echo '<td>'.$row["FIETSPOSTID"].'</td>';
      echo '</tr>';
      }
       ?>
    </tbody>
    <tfoot>
    <tr><th colspan="4">
      <div class="ui right floated pagination menu">                
       <a class="icon item" href="fietsen.php?nummer=<?php echo $nummer - 10; ?> "> <i class="left chevron icon"></i></a>       
       <a class="icon item" href="fietsen.php?nummer=<?php echo $nummer + 10; ?> "> <i class="right chevron icon"></i></a> 
      </div></th>
  </tr></tfoot>
 </table>
 
 <br>
 <form action="" method="post">
 <h2>Fiets gecontroleerd:</h2>
<?php
if(isset($_POST['Controle'])){ 
    if(!empty($_POST['FietsID']) && !empty($_POST['Taken'])){
      if(is_numeric($_POST['FietsID'])){
        if(ongroundControle($_POST['FietsID'],$_POST['Taken'],$_POST['Beschrijving'], $_SESSION["WerknemerID"])){;
          // header('Location: fietsen.php?succes=1');
          // exit;
          echo '<script>$(location).attr("href", "fietsen.php?succes=1")</script>'; //Pleister oplossing
        }
        } else { toonError2("Voer een geldig fietsnummer in.");}
      } else { toonError2("Er is geen Fietsnummer of taak toegevoegd.");}     
    }
    if(isset($_GET['succes']) && $_GET['succes'] == 1 ){
      toonSucces("Fiets is succesvol gecontroleerd.");
    } 
?>
<div class="ui inverted segment">
  <div class="ui inverted form">
    
      <div class="field">
        <label>Fietsnummer:</label>
        <input type="text" name="FietsID" <?php if(isset($Fietsnummer)){echo 'value="'.$Fietsnummer.'"';} ?>/>
      </div>
      <div class="grouped fields">
      <p>Welke taken zijn verricht?</p>
       <select name="Taken[]" class="ui selection dropdown multi-select" multiple="">
       <?php 
       $taken = getTaken();
       
       foreach($taken as $row){
       
       echo '<option value="'.$row['TAAKID'].'">'.$row['TAAKNAAM'].'</option>';
       }
?>
      </select>
    </div>
       
    <div class="field">
        <label>Extra Beschrijving (Niet Verplicht):</label>
        <textarea rows="2" name="Beschrijving"></textarea>
      </div>
      <input class="ui submit button" type="submit" class="button" name="Controle" value="Voltooi">
      </div>
    </div>
</form>
 
 <br>
 <form action="" method="post">
 <h2>Onderdeel vervangen:</h2>
<?php 
   if(isset($_POST['Reparatie'])){
    if(is_numeric($_POST['FietsID'])){
      if(!empty($_POST['Dropdown'][0])){
        if(checkOnderdelen($_POST['Dropdown'])){
          if(insertReparatie(NULL,$_POST['FietsID'], $_POST['Dropdown'], $_SESSION["WerknemerID"])){
            toonSucces("Fiets is succesvol gerepareerd. Vergeet niet de controle te voltooien.");
          }
          }
        } else {toonError2("Geen onderdeel geselecteerd.");}
        } else {toonError2("Voer een geldig fietsnummer in.");}
      }
?>
 <div class="ui inverted segment">
  <div class="ui inverted form">
    
      <div class="field">
        <label>Fietsnummer:</label>
        <input type="text" name="FietsID" <?php if(isset($Fietsnummer)){echo 'value="'.$Fietsnummer.'"';} ?>/>
      </div>
  <div class="container1">
    <button class="add_form_field">Nieuw onderdeel &nbsp; <span style="font-size:16px; font-weight:bold;">+ </span></button>
    <div id="Onderdelen">
      <select class="ui search dropdown" id="search-select" name="Dropdown[]" style="width: 30%">
        <option value="">Onderdeel</option>
        <?php 
        $onderdelen = getAlleOnderdelen();
        
        foreach($onderdelen as $row){      
          echo "<option value=" . $row['ONDERDEELID'] . ">" . $row['NAAM'] . "</option>";            
        }
        ?>
      </select>    
      <a href="#" class="delete">Delete</a>
      </div>
    </div>
      <input class="ui submit button" type="submit" class="button" name="Reparatie" value="Voltooi">
    </div>
    </div>
</form>
 
 <br>
<form action="" method="post">
<h2>Fiets naar Workshop:</h2>
 <?php 
 if(isset($_POST['naarWorkshop'])){
  if(!empty($_POST['FietsID']) && !empty($_POST['WorkshopID'])){
  if(is_numeric($_POST['FietsID']) && is_numeric($_POST['WorkshopID'])){       
   if(naarWorkshop($_POST['FietsID'],$_POST['WorkshopID'],$_POST['Beschrijving'])){
    // header('Location: fietsen.php?succes=3');
    // exit;
    echo '<script>$(location).attr("href", "fietsen.php?succes=3")</script>'; //Pleister oplossing
  }
  } else toonError2("Voer een geldig fietsnummer in."); 
} else {
  toonError2("Fietsnummer of Workshopnummer is niet ingevuld.");
  }  
}

if(isset($_GET['succes']) && $_GET['succes'] == 3 ){
  toonSucces("Fiets is succesvol naar de workshop gestuurt.");
}
?>
  <div class="ui inverted segment">
  <div class="ui inverted form">
    <div class="two fields">
      <div class="field">
        <label>Fietsnummer:</label>
        <input type="text" name="FietsID" <?php if(isset($Fietsnummer)){echo 'value="'.$Fietsnummer.'"';} ?>>
      </div>
      <div class="field">
        <label>Workshopnummer:</label>
        <input type="text" name="WorkshopID">
      </div>
    </div>
    <div class="field">
        <label>Beschrijving :</label>
        <textarea rows="3" name="Beschrijving"></textarea>
      </div>

    <input class="ui submit button" type="submit" class="button" name="naarWorkshop" value="Voltooi">
  </div>
</div>
</form>
<br>
<br>

</div>
<script>
$('.multi-select')
  .dropdown();
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