<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';
  
  if (!$admin){
    header('Location: index.php');
    exit;
  }

	parse_str($_SERVER['QUERY_STRING']);
?>
<div class="ui center aligned text container">
	<h1> Bestellingen </h1>
	<?php
	if(isset($_POST['bestellingVerwijderen'])){
		verwijderOrder($_POST['bestellingVerwijderen']);
	} else if (isset($_POST['bestellingBinnengekomen'])){
		markeerBestellingBinnengekomen($_POST['bestellingBinnengekomen']);
	}
	?>
</div>
<div class="ui container">

<select class="ui search selection dropdown" id="search-select" onChange="window.document.location.href=this.options[this.selectedIndex].value;">
  <option value="">Selecteer Workshop:</option>
			<?php workshopSelect('adminBestellingen',$Workshop);?>    
</select>
	<?php if(isset($Workshop)){ ?>
	<table class="ui celled unstackable table">
		<thead>
			<tr>
        		<th>OrderID</th>
				<th>OnderdeelID</th>
				<th>Naam</th>
				<th>Aantal besteld</th>
				<th>Binnengekomen</th>
				<th>Verwijderen</th>
			</tr>
		</thead>
		<tbody>
			<?php toonBestellijst($Workshop,true);?>
		</tbody>
	</table>
</div>
<?php } ?>

<?php   
	include 'includes/footer.php';
?>