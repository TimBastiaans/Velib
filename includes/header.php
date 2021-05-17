<?php 
// HTML/CSS door: Marco Schattevoet (517538) 
// PHP door: Marco Schattevoet (517538)

/*Debugging tools: */
$login = false;
$voornaam= "Bob";
$admin = false;
/*Einde Debugging Tools*/

session_start();
require("connectdatabase.php");
require("functions.php");


if (array_key_exists('WerknemerID', $_SESSION)) {
	$login = true;                             
	$voornaam = $_SESSION["WerknemerID"];
	$admin = checkAdmin($_SESSION["WerknemerID"]);
	controleerActief($_SESSION["WerknemerID"]);
}


$huidigePagina = basename($_SERVER['PHP_SELF']);

if ($huidigePagina != "inloggen.php"){
	if(!$login){
		header('Location: inloggen.php');
		exit;
	}
}


?>

<!DOCTYPE html>
<html lang="nl">
<head>
	<meta charset="UTF-8">
	<title>Velib</title>
	<link rel="stylesheet" type="text/css" href="css/semantic.min.css">
	<script
	src="https://code.jquery.com/jquery-3.1.1.min.js"
	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
	crossorigin="anonymous"></script>
	<script src="css/semantic.min.js"></script>
</head>

<body>
	<div class="ui six item menu">
		<a class="item">Velib</a>
		<?php if($login){
			echo '<a href="index.php" class="'; if($huidigePagina == "index.php"){echo 'active ';}  echo 'item">Home</a>';
			if (isInTeam($_SESSION["WerknemerID"]) || $admin){
				echo '<a href="fietsen.php" class="'; if($huidigePagina == "fietsen.php"){echo 'active ';}  echo 'item">Fietsen</a>';
			}
			if (isInWorkshopTeam($_SESSION["WerknemerID"]) || $admin){
				echo '<a href="inventaris.php" class="'; if($huidigePagina == "inventaris.php" || $huidigePagina == "bestellijst.php"){echo 'active ';}  echo 'item">Inventaris</a>
				<a href="reparatie.php" class="'; if($huidigePagina == "reparatie.php"){echo 'active ';}  echo 'item">Reparatie</a>';
			}
			echo '<a href="uitloggen.php" class="item">Uitloggen</a>';
		}
		?>
	</div>

<?php 
	if($admin){
		include("adminBar.php");
	}
?>