<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';
  
  if (!$admin){
    header('Location: index.php');
    exit;
  }
?>

<div class="ui text grid">
<div class="two wide column"></div>  
	<div class="five wide column">
		<h1> Rooster Monteur Toevoegen </h1>
    <?php
    if(isset($_POST['RoosterMonteurToevoegen'])){
      if(!empty($_POST['datum']) && !empty($_POST['workshopID']) && !empty($_POST['werknemerID']) && !empty($_POST['starttijd']) && !empty($_POST['eindtijd'])){
        if(is_numeric($_POST['werknemerID']) && is_numeric($_POST['workshopID'])){
     $datum = $_POST['datum'];
     $start = $datum .' '. $_POST['starttijd'];
     $eind = $datum .' '. $_POST['eindtijd'];
     
      if(roosterMonteurToevoegen($_POST['werknemerID'], $start, $_POST['workshopID'], $eind)){
        toonSucces("Werknemer " . $_POST['werknemerID'] . " is ingepland op $start tot $eind in workshop " . $_POST['workshopID'] . ".");
      }
      } else {toonError2("Voer een geldig workshop of werknemer id in.");} 
      } else {toonError2("Een van de velden is niet ingevuld");}                
    }
    
    ?>
		<form class="ui form" action="" method="post"> 
			<div class="field">
				<label>Datum:</label>
				<input type="date" name="datum">
			</div>
			<div class="field">
				<label>Workshop ID:</label>
				<input type="text" name="workshopID" placeholder="workshopID">
			</div>
			<div class="field">
				<label>Werknemer ID:</label>
				<input type="text" name="werknemerID" placeholder="werknemerID">
			</div>
			<div class="field">
				<label>Starttijd:</label>
				<input type="time" name="starttijd">
			</div>
			<div class="field">
				<label>Eindtijd:</label>
				<input type="time" name="eindtijd">
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="RoosterMonteurToevoegen" value="Toevoegen">
		</form>
	</div>

	<div class="four wide column">
		<h1> Rooster Werknemer in Team Toevoegen </h1>
    <?php 
    if(isset($_POST['WerknemerInTeamToevoegen'])){
      if(!empty($_POST['werknemer']) && !empty($_POST['team'])){
        if(is_numeric($_POST['werknemer']) && is_numeric($_POST['team'])){
           if(werknemerInTeamToevoegen($_POST['werknemer'], $_POST['team'])){
            toonSucces("Werknemer is in team gezet");
           }
         } else { toonError2("Voer een geldig werknemer en team id in.");}
       } else { toonError2("Een van de velden is niet ingevuld.");}
    }
    ?>
			<form class="ui form" action="" method="post">
			<div class="field">
				<label>Werknemer ID:</label>
				<input type="text" name="werknemer" placeholder="werknemerID">
			</div>
			<div class="field">
				<label>Team:</label>
				<input type="text" name="team" placeholder="Team">
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="WerknemerInTeamToevoegen" value="Toevoegen">
		</form>
	</div>
  
  <div class="four wide column">
		<h1> Routingcard </h1>
    <?php 
    if(isset($_POST['RoutingcardToevoegen'])){
      if(!empty($_POST['team']) && !empty($_POST['station']) && !empty($_POST['datum']) && !empty($_POST['tijd'])){
        if(is_numeric($_POST['team']) && is_numeric($_POST['station'])){
            $datum = $_POST['datum'] . ' ' . $_POST['tijd'];
            if(routingCard($_POST['team'], $datum, $_POST['station'])){
              toonSucces("Routingcard toegevoegd.");
            }
          } else {toonError2("Voer een geldig team en station id in.");}
      } else {toonError2("Een van de velden is niet ingevuld.");}
    }
    ?>
			<form class="ui form" action="" method="post">
			<div class="field">
				<label>Team ID:</label>
				<input type="text" name="team" placeholder="TeamID">
			</div>
			<div class="field">
				<label>Station ID:</label>
				<input type="text" name="station" placeholder="StationID">
			</div>
      	<div class="field">
				<label>Datum:</label>
				<input type="date" name="datum">
			</div>
      	<div class="field">
				<label>Tijd:</label>
				<input type="time" name="tijd">
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="RoutingcardToevoegen" value="Toevoegen">
		</form>
	</div>
</div>


<?php   
	include 'includes/footer.php';
?>