<?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	include 'includes/header.php';
  
  $namen = getGebruikerNamen($_SESSION["WerknemerID"]);
  parse_str($_SERVER['QUERY_STRING']);
  
 
  
  if(isset($Jaar)){
   $Year = $Jaar;
  } else {
   $Year = date('Y');
  }
  
  $dt = new DateTime('December 28th,'. $Year);
  $dt = $dt->format('W');

 if(isset($Week)){
   if($Week == 0){
    $Year--;
    $dt = new DateTime('December 28th,'. $Year);
    $dt = $dt->format('W');
    header("Location: index.php?Week=$dt&Jaar=$Year");
     exit; 
   }
  }
     
  if(isset($Week)){
   $weeknummer = $Week;
  } else {
   $weeknummer = date('W');
  }
    
  $StartAndEndDate = getStartAndEndDate($weeknummer,$Year);
  $startDate = $StartAndEndDate["week_start"];
  $endDate =  $StartAndEndDate["week_end"];
  $dienst = getMonteurDienstPerWeek($_SESSION["WerknemerID"], $startDate, $endDate);
   
  if (isset($Week)){
    if($dt < $Week){
     $Year++;
     $weeknummer = 1;
     header("Location: index.php?Week=$weeknummer&Jaar=$Year");
     exit;
    }
  }
  
?>

<div class="ui text container">
	<h1>Welkom, <?php echo $namen["VOORNAAM"] , " ", $namen["ACHTERNAAM"];?></h1>
</div>
<div class="ui text container">
	<h2>Rooster werkplaats:</h2>  
  <?php
  $startDate = new DateTime($startDate);
  $endDate = new DateTime($endDate);
  echo "Week: $weeknummer <br>";
  echo "Datum: ". $startDate->format('d-m-Y') . " t.e.m " .$endDate->format('d-m-Y'); 
  ?>
  <br>
<button class="ui left labeled icon button" onclick="location.href ='index.php?Week=<?php echo $weeknummer - 1;?>&Jaar=<?php echo $Year ?>' ">
  <i class="left arrow icon"></i>
  Vorige
</button>

<button class="ui right labeled icon button" onclick="location.href ='index.php?Week=<?php echo $weeknummer + 1;?>&Jaar=<?php echo $Year ?>' ">
  <i class="right arrow icon"></i>
  Volgende
</button>
<?php if(!empty($dienst)){ ?>
  <table class="ui celled unstackable table">
    <thead>
      <tr>
        <th>Dag</th>
        <th>Datum</th>
        <th>Werkplaats</th>
        <th>Van</th>
        <th>Tot</th>
      </tr>
    </thead>
    <tbody>
      
      <?php       
       foreach($dienst as $row){
        $date = new DateTime($row['START_DATUM']);
        $endDate = new DateTime($row['EIND_TIJD']);
        $dag = $date->format('l');
        $dag = convertDag($dag);
        echo '<tr>';
        echo '<td>' . $dag . '</td>';
        echo '<td>' . $date->format('d-m-Y') . '</td>';
        echo '<td>' . $row['WORKSHOPID'] . '</td>';
        echo '<td>' . $date->format('H:i') . '</td>';
        echo '<td>' . $endDate->format('H:i') . '</td>';
        echo '</tr>';
      }
      ?>
    </tbody>
 </table>
<?php } ?>
</div>
 <br>
<div class="ui text container">
	
  <?php
  if (isset($Dag)){ 
   $Datum = new DateTime($Dag);
  } else {
  $Datum = new DateTime();
  }
  $Datum->format('Y-m-d');
  $TeamID = GetTeamIdVanWerknemer($_SESSION["WerknemerID"]);
  
  if(!empty($TeamID)){
  ?>
  <h2>Rooster onground:</h2>
  <p>Team: <?php echo $TeamID; ?></p>
  <p>Datum: <?php echo $Datum->format('d-m-Y'); ?></p> 
  

  <button class="ui left labeled icon button" onclick="location.href ='index.php?Dag=<?php echo ($Datum->modify('-1 day'))->format('Y-m-d'); ?>' ">
  <i class="left arrow icon"></i>
  Vorige
</button>

<button class="ui right labeled icon button" onclick="location.href ='index.php?Dag=<?php echo ($Datum->modify('+2 day'))->format('Y-m-d'); ?>' ">
  <i class="right arrow icon"></i>
  Volgende
</button>
<?php 
    $Datum->modify('-1 day');
    $RoutingCard = getRoutingCard($TeamID, $Datum->format('Y-m-d'));
     if(!empty($RoutingCard)){ ?>
  <table class="ui celled unstackable table">
    <thead>
      <tr>
        <th>Arrondissement</th>
        <th>Stationnummer</th>
        <th>Tijd</th>
        <th>Fietspost</th>
        <th>Fietsnummer</th>
      </tr>
    </thead>
    <tbody>
    <?php

    
    $aantal = 0;
    $teller = 0;
    $Fietspost = null;
    $Fietsnummer = null;
    
    foreach($RoutingCard AS $Row){
    $aantal++;   
    $tijd = new DateTime($Row['RITDATUM']);
                                             
      if($teller == 0){
         echo '<tr>';
         echo '<td>' . $Row["ARRONDISSEMENT"] . '</td>';
         echo '<td>' . $Row["STATIONNUMMER"] . '</td>';
         echo '<td>' . $tijd->format('H:i') . '</td>';
      }
      
     if($aantal >= count($RoutingCard)){
         $Fietspost = $Fietspost . $Row["FIETSPOSTID"] . "<br>"; 
         $Fietsnummer =  $Fietsnummer . $Row["FIETSPOSTID"] . "<br>";
         echo '<td>' . $Fietspost . '</td>';
         echo '<td>' . $Fietsnummer . '</td>';
     } else if( ($Row["ARRONDISSEMENT"] == $RoutingCard[$aantal]["ARRONDISSEMENT"]) && ($Row["STATIONNUMMER"] == $RoutingCard[$aantal]["STATIONNUMMER"]) ){
         $teller++;
         $Fietspost = $Fietspost . $Row["FIETSPOSTID"] . "<br>"; 
         $Fietsnummer =  $Fietsnummer . $Row["FIETSID"] . "<br>";
     } else if ($teller > 0){
         $teller = 0;
         $Fietspost = $Fietspost . $Row["FIETSPOSTID"] . "<br>"; 
         $Fietsnummer =  $Fietsnummer . $Row["FIETSID"] . "<br>";
         echo '<td>' . $Fietspost . '</td>';
         echo '<td>' . $Fietsnummer . '</td>';
         $Fietspost = null;
         $Fietsnummer = null;
     } else {
         $teller = 0;         
         $Fietspost = $Row["FIETSPOSTID"];
         $Fietsnummer = $Row["FIETSID"];
         echo '<td>' . $Fietspost . '</td>';
         echo '<td>' . $Fietsnummer . '</td>';
         $Fietspost = null;
         $Fietsnummer = null;
     }    
     if($teller == 0){
     echo '</tr>';     
     }
      
    }
    ?>
    </tbody>
 </table>
<?php
 } else {echo "<br>Er is geen rooster aan team $TeamID gekoppeld op deze dag. ";}
 } ?> 
</div>
<?php   
	include 'includes/footer.php';
?>