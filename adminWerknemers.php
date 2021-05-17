<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';
  if (!$admin){
    header('Location: index.php');
    exit;
  }
  
  parse_str($_SERVER['QUERY_STRING']);
  
?>


  <div class="ui grid">
  <div class="one wide column"></div>
   <div class="five wide column">
	   <h1> Werknemer Toevoegen </h1>
     <?php 
    if(isset($_POST['WerknemerToevoegen'])){
      if(!empty($_POST['Voornaam']) && !empty($_POST['Achternaam']) && !empty($_POST['Adres']) && !empty($_POST['Postcode']) && !empty($_POST['password'])){
      $werknemerID = voegWerknemerToe($_POST['Voornaam'], $_POST['Achternaam'], $_POST['Adres'], $_POST['Postcode'], $_POST['password']);
      
        if(!empty($werknemerID)){
          toonSucces("Werknemer ". $_POST['Voornaam']." " . $_POST['Achternaam'] . " is toegevoegd. Het ID is $werknemerID");
        } else { toonError2("Het toevoegen van werknemer ". $_POST['Voornaam']." " . $_POST['Achternaam'] . " is mislukt"); }
      } else {toonError2("Een van de velden is niet ingevuld");}  
    }
?>
     <form action="" method="post">
        <div class="ui form">
        	<div class="field">		
        			<label>Voornaam:</label>
        			<input type="text" name="Voornaam" placeholder="Voornaam"/>
        	</div>
          <div class="field">		
        			<label>Achternaam:</label>
        			<input type="text" name="Achternaam" placeholder="Achternaam"/>
        	</div>
           <div class="field">		
        			<label>Adres:</label>
        			<input type="text" name="Adres" placeholder="Adres" />
        	</div>
           <div class="field">		
        			<label>Postcode:</label>
        			<input type="text" name="Postcode" placeholder="Postcode" />
        	</div>
           <div class="field">		
        			<label>Wachtwoord:</label>
        			<input type="password" name="password" placeholder="Wachtwoord">
        	</div>
          <input class="ui large teal submit button" type="submit" class="button" name="WerknemerToevoegen" value="Voltooi">
        </div>
     </form>
   </div>
   
   
   <div class="six wide column">
   
   <?php 
   

   ?>
  
	   <h1> Werknemers </h1>
     
     
     <?php
      
     
     if(isset($_POST['VerwijderWerknemer']) || isset($_POST['Activeren'])){
      if($_POST['WerknemerVerwijderen'] != $_SESSION["WerknemerID"]){
        if(isset($_POST['Activeren'])){
          if(ActiverenWerknemer($_POST['WerknemerActief'])){
            if(isActief($_POST['WerknemerActief'])){
            toonSucces("Werknemer ". $_POST['WerknemerActief'] . " is nu actief.");
             
            } else {
              toonSucces("Werknemer ". $_POST['WerknemerActief'] . " is nu gedeactiveerd.");
            }
          }
        } else {      
          if(verwijderWerknemer($_POST['WerknemerVerwijderen'])){
          toonSucces("De werknemer is verwijderd.");
          }
        }
      } else { toonError2("Error: U mag uwzelf niet deactiveren of verwijderen.");}
     } 
     
     ?>
          
    <table class="ui sortable celled table">   
		<thead>
			<tr>
				<th class="">ID</th>
				<th class="">Voornaam</th>
				<th class="">Achternaam</th>
        <th class="">Actief</th>
				<th class="">Verwijder</th>
			</tr>
		</thead>
		<tbody>
    <?php     

      $werknemers = getWerknemers();

    $aantal = 0;
    if(!isset($nummer)){
     $nummer = 0;
    }
    
    foreach($werknemers as $row){
    $aantal++;
      if($aantal <= $nummer){
    continue;
    }
      if($aantal > $nummer + 10){
      break;
      }
      echo '<tr>';
        echo '<form action="" method="post">';
        echo '<td>' . $row["WERKNEMERID"]. '</td>';
        echo '<td>' . $row['VOORNAAM'] . '</td>';
        echo '<td>' . $row['ACHTERNAAM'] . '</td>';
        	echo '<td>';
          echo '<input type="hidden" name="WerknemerActief" value="'.$row["WERKNEMERID"].'">';
					echo '<input class="ui fluid small teal submit button" type="submit" class="button" name="Activeren" value="';
           if(isActief($row["WERKNEMERID"])){ echo 'Deactiveren">';} else {echo 'Activeren">';}
					echo '</td>';        
				echo '<td>
         <input type="hidden" name="WerknemerVerwijderen" value="'.$row["WERKNEMERID"].'">
						<input class="ui fluid small teal submit button" type="submit" class="button" name="VerwijderWerknemer" value="Verwijder">
					</td>
				</form>';
        echo '</tr>';
    }
    
    ?>
    </tbody>
    <tfoot>
    <tr><th colspan="5">
      <div class="ui right floated pagination menu">                
       <a class="icon item" href="adminWerknemers.php?nummer=<?php echo $nummer - 10; ?> "> <i class="left chevron icon"></i></a>       
       <a class="icon item" href="adminWerknemers.php?nummer=<?php echo $nummer + 10; ?> "> <i class="right chevron icon"></i></a> 
      </div>
    </th>
  </tr></tfoot>   
	 </table>
   
   
   
   
   </div>
   
   
   <div class="four wide column">
      <h1> Admin maken</h1>
      <?php 
      if(isset($_POST['AdminMaken'])){
        if(!empty($_POST['WerknemerID'])){
          if(is_numeric($_POST['WerknemerID'])){
            if(!checkAdmin($_POST['WerknemerID'])){
              if(adminMaken($_POST['WerknemerID'])){
              toonSucces("Werknemer " . $_POST['WerknemerID'] . " is nu een admin");
              } 
          }else {
            toonError2("Gebruiker " . $_POST['WerknemerID'] . " is al een admin.");
          }
         } else {toonError2("Voer een geldig id nummer in.");}
        } else {toonError2("Werknemer id is niet ingevuld.");}
     }
      ?>
      <form action="" method="post">
        <div class="ui form">
        	<div class="field">		
        			<label>WerknemerID:</label> 
        			<input type="text" name="WerknemerID"/>
          </div>
          <input class="ui large teal submit button" type="submit" class="button" name="AdminMaken" value="Voltooi">
        </div>
     </form>
   </div>
   
  </div>

 <script src="includes/tablesort.js"></script> 
<script>
$('table').tablesort()
</script>
<?php   
	include 'includes/footer.php';
?>