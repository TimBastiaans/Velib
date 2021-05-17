<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
  parse_str($_SERVER['QUERY_STRING']);
	include 'includes/header.php';
  
  if (!$admin){
    header('Location: index.php');
    exit;
  }
  
    
?>

<div class="ui grid">
<div class="one wide column"></div>
<div class="seven wide column">
	<h1>Event toevoegen</h1>
  <?php 
  if(isset($_POST["EventToevoegen"])){
  if(!empty($_POST["naam"]) && !empty($_POST["datum"]) && !empty($_POST["tijd"])){
   if(checkDatum($_POST["datum"])){
      if(EventToevoegen($_POST["naam"], $_POST["datum"], $_POST["tijd"], $_POST["Beschrijving"])){
       toonSucces("Event is toegevoegd.");
      } 
     } else {
      toonError2("Error, de datum is al geweest.");
     }
   } else {
    toonError2("Error, een van de velden is niet ingevuld");
   }
  }
  ?>
 <form class="ui form" action="" method="post">
			<div class="field">
				<label>Event naam:</label>
				<input type="text" name="naam" placeholder="Event naam">
			</div>
      	<div class="field">
				<label>Datum:</label>
				<input type="date" name="datum">
			</div>
      <div class="field">
				<label>Tijd:</label>
				<input type="time" name="tijd">
			</div>
      <div class="field">		
        <label>Beschrijving:</label>
        <textarea rows="3" name="Beschrijving"></textarea>
      </div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="EventToevoegen" value="Toevoegen">
		</form> 
 
</div>
<div class="seven wide column">
  <h1>Station aan event toevoegen</h1>
  <?php 
  if(isset($_POST['StationaanEventToevoegen'])){
    if(!empty($_POST['StationID'])){
      if(stationAanEventToevoegen($_POST['Events'], $_POST['StationID'])){
       toonSucces("Station ". $_POST['StationID'] . " is aan evenement ". $_POST['Events'] ." toegevoegd.");
      }
    } else { toonError2("Station is niet ingevuld");}
  }
  
  ?>
      <form class="ui form" action="" method="post">
      <div class="field">
				<label>Selecteer event:</label>
				 <select class="ui search selection dropdown search-select" name="Events">
          <option value="">Event</option>
          <?php
          $events = getKomendeEvenementen(); 
          foreach($events as $row){
          echo '<option value="'. $row['EVENTID'] .'">'. $row['NAAM'] . ' '. $row['DATUM'].'</option>';    
          }
          ?>
         </select>
			</div>
      <div class="field">
				<label>Station ID:</label>
				<input type="text" name="StationID" placeholder="Station ID">
			</div>
      	<input class="ui fluid large teal submit button" type="submit" class="button" name="StationaanEventToevoegen" value="Toevoegen"> 
        </form>
</div>
<div class="one wide column"></div>


<div class="one wide column"></div>
<div class="seven wide column">
<h1>Event verwijderen</h1>
<?php 

if(isset($_POST['EventVerwijderen'])){
  if(EvenementVerwijderen($_POST['Events'])){
   toonSucces("Evenement is verwijderd.");
  }
}

?>
 <form class="ui form" action="" method="post">
  <div class="field">
				<label>Selecteer event:</label>
				 <select class="ui search selection dropdown search-select" name="Events">
          <option value="">Event</option>
          <?php
          $events = getKomendeEvenementen(); 
          foreach($events as $row){
          echo '<option value="'. $row['EVENTID'] .'">'. $row['NAAM'] . ' '. $row['DATUM'].'</option>';      
          }
          ?>
         </select>
	</div>
  <input class="ui fluid large teal submit button" type="submit" class="button" name="EventVerwijderen" value="Verwijderen"> 
  </form>    
</div>
<div class="seven wide column">
  <h1>Station aan event verwijderen</h1>
 <?php  
 if(isset($_POST['StationAanEventVerwijderen'])){
   if(StationAanEvenementVerwijderen($_POST['Events'] ,$_POST['Stations'])){
    toonSucces("Station aan evenement is verwijderd");
   } 
  }
  ?>
  <form class="ui form" action="" method="post">
  <div class="field">
				<label>Selecteer event:</label>
				 <select class="ui search selection dropdown search-select" name="Events" onChange="window.document.location.href='adminEvents.php?Evenement=' + this.options[this.selectedIndex].value;">
          <option value="">Event</option>
          <?php
          $events = getKomendeEvenementen(); 
          foreach($events as $row){
          echo '<option value="'. $row['EVENTID'] .'"';
          if(isset($Evenement) && $Evenement == $row['EVENTID']){
          echo 'selected';
          }
          echo'>'. $row['NAAM'] . ' '. $row['DATUM'].'</option>';    
          }
          ?>
         </select>
	</div>
  <div class="field">
  <?php if(isset($Evenement)){ ?>
				<label>Selecteer event:</label>
				 <select class="ui search selection dropdown search-select" name="Stations">
          <option value="">Station</option>
          <?php 
          $Stations = getStationsAanEvenement($Evenement);
          foreach($Stations as $row){
          echo '<option value="'. $row['STATIONID'] .'">'. $row['STATIONID']. '</option>';            
            }
          ?>
         </select>
	</div>
  <input class="ui fluid large teal submit button" type="submit" class="button" name="StationAanEventVerwijderen" value="Verwijderen">
  <?php } ?> 
  </form>
</div>
<div class="one wide column"></div>
 </div>

<?php   
	include 'includes/footer.php';
?>