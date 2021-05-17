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

	if (isset($_POST["aanpassenInventarisPlus"])){
		if(is_numeric($_POST["nieuwInventaris"]) && $_POST["nieuwInventaris"] > 0){
			if(inventarisBijwerken($Workshop, $_POST["onderdeelID"], $_POST["nieuwInventaris"], 1)){
				toonSucces("Inventaris is bijgewerkt");
			}
		}
		else{
			toonError2("Geef een geldig getal.");
		}
	}

	else if (isset($_POST["aanpassenInventarisMin"])){
		if(is_numeric($_POST["nieuwInventaris"]) && $_POST["nieuwInventaris"] > 0){
			if(inventarisBijwerken($Workshop, $_POST["onderdeelID"], $_POST["nieuwInventaris"], 0)){
				toonSucces("Inventaris is bijgewerkt");
			}
		}
		else{
			toonError2("Geef een geldig getal.");
		}
	}

	else if (isset($_POST["toevoegenLijst"])){
    if(is_numeric($_POST["aantalTeBestellen"]) && $_POST["aantalTeBestellen"] > 0){
		$goedkoopsteLeverancier = getGoedkoopsteLeverancier($_POST["onderdeelID"]);
    if(onderdeelBestellen($Workshop, $goedkoopsteLeverancier, $_POST["onderdeelID"], $_POST["aantalTeBestellen"])){
     toonSucces("Onderdelen zijn besteld.");
    }
    } else {toonError2("Geef een geldig getal.");}
	}

?>

<div class="ui four column grid">
	<div class="row">	
		<div class="column"></div>
		<div class="column">
			<div class="ui basic center aligned segment">
				<div class="text container">
					<h1>Inventaris</h1>
				</div>
			</div>
		</div>
		<div class="column">
			<div class="ui basic center aligned segment">
				<a href="bestellijst.php"><h1>Bestellijst</h1></a>
			</div>
		</div>
	</div>
</div>


</br></br>



<div class="ui container">
	<div class="field"> 
		<select class="ui search selection dropdown" id="search-select" onChange="window.document.location.href=this.options[this.selectedIndex].value;">
			<option value="">Selecteer Workshop:</option>
			<?php workshopSelect('inventaris',$Workshop);?>                                                          
		</select> 
	</div>
	<?php if(isset($Workshop)){ ?>
	<table class="ui celled unstackable table">
		<thead>
			<tr>
				<th>ID:</th>
				<th>Naam:</th>
				<th>Aantal in magazijn:</th>
				<th>Aantal minimaal nodig:</th>
        <th>Aantallen bewerken</th>
				<th>Bestellen</th>
			</tr>
		</thead>
		<tbody>
			<?php toonInventaris($Workshop);?>
		</tbody>
	</table>
</div>
<?php } ?>


<?php   
	include 'includes/footer.php';
?>