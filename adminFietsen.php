<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';
  
  if (!$admin){
    header('Location: index.php');
    exit;
  }

?>

<div class="ui center aligned text container">
	<br>
</div>

<div class="ui text container grid">
	<div class="eight wide column">
		<h1> Fiets Toevoegen </h1>
		<?php 
			if (isset($_POST["toevoegKnopFiets"])){
        if(!empty($_POST["fietsID"]) && !empty($_POST["workshopID"])){
          if(is_numeric($_POST["fietsID"]) && is_numeric($_POST["workshopID"])){
            fietsToevoegen($_POST["fietsID"], $_POST["workshopID"]);
            } else {toonError2("Fiets en workshop id moeten een nummer zijn.");}
          } else {toonError2("Een van de velden is niet ingevuld.");}
			}
		?>
		<form action="" method="post" class="ui form">
			<div class="field">
				<label>Fietsnummer:</label>
				<input type="text" name="fietsID" placeholder="Fietsnummer">
			</div>
			<div class="field">
				<label>Workshop ID:</label>
				<input type="text" name="workshopID" placeholder="workshopID">
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="toevoegKnopFiets" value="Toevoegen">
		</form>

	</div>

	<div class="eight wide column">
		<h1> Fiets Verwijderen </h1>
		<?php 
			if (isset($_POST["verwijderKnopFiets"])){
        if(!empty($_POST["fietsID"])){
          if(is_numeric($_POST["fietsID"])){
			     fietsVerwijderen($_POST["fietsID"]);
        } else { toonError2("Fiets id moet een nummer zijn.");}
       } else {toonError2("Fiets id is niet ingevuld.");}
			}
		?>
		<form action="" method="post" class="ui form">
			<div class="field">
				<label>Fiets ID:</label>
				<input type="text" name="fietsID" placeholder="fietsID">
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="verwijderKnopFiets" value="Verwijderen">
		</form>
	</div>

	<div class="eight wide column">
		<h1> Controle Taken Toevoegen </h1>
		<?php 
			if (isset($_POST["toevoegKnopControle"])){
        if(!empty($_POST["beschrijvingControle"])){
			   controletaakToevoegen($_POST["beschrijvingControle"]);
        } else {toonError2("Voer een beschrijving in.");}
			}
		?>
		<form action="" method="post" class="ui form">
			<div class="field">
				<label>Beschrijving:</label>
				<textarea name="beschrijvingControle" rows="4" cols="20"></textarea>
			</div>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="toevoegKnopControle" value="Toevoegen">
		</form>
	</div>

	<div class="eight wide column">
		<h1> Controle Taken Verwijderen </h1>
		<?php 
			if (isset($_POST["verwijderKnopControle"])){
        if(!empty($_POST["TaakID"])){
			     controletaakVerwijderen($_POST["TaakID"]);
        } else {toonError2("Kies een taak.");}
			}
		?>
		<form action="" method="post" class="ui form">
			<div class="field">		
				<label>Taak:</label>
				<select class="ui search selection dropdown search-select" name=TaakID>
					<option value="">Taak</option>
					<<?php geefSelectControleTaken(); ?>
				</select>
			</div>
			<br>
			<input class="ui fluid large teal submit button" type="submit" class="button" name="verwijderKnopControle" value="Verwijderen">
		</form>
	</div>

</div>

<script>
$('.search-select')
  .dropdown()
;
</script>

<?php   
	include 'includes/footer.php';
?>