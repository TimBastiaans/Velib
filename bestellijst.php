<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';

	parse_str($_SERVER['QUERY_STRING']);
?>

<div class="ui four column grid">
	<div class="row">	
		<div class="column"></div>
		<div class="column">
			<div class="ui basic center aligned segment">
				<div class="text container">
					<a href="inventaris.php"><h1>Inventaris</h1></a>
				</div>
			</div>
		</div>
		<div class="column">
			<div class="ui basic center aligned segment">
				<h1>Bestellijst</h1>
			</div>
		</div>
	</div>
</div>


</br></br>


<div class="ui container">

<select class="ui search selection dropdown" id="search-select" onChange="window.document.location.href=this.options[this.selectedIndex].value;">
  <option value="">Selecteer Workshop:</option>
			<?php workshopSelect('bestellijst',$Workshop)?>    
</select>
	<?php if(isset($Workshop)){ ?>
	<table class="ui celled unstackable table">
		<thead>
			<tr>
        		<th>OrderID</th>
				<th>OnderdeelID</th>
				<th>Naam</th>
				<th>Aantal besteld</th>
			</tr>
		</thead>
		<tbody>
			<?php toonBestellijst($Workshop,false);?>
		</tbody>
	</table>
</div>
<?php } ?>


<?php   
	include 'includes/footer.php';
?>