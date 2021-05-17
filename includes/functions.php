<?php

function uitloggen(){
    session_destroy();
    $_SESSION = array();
    header("Location: inloggen.php"); 
    exit();
}

function isActief($gebruiker){
  //Bepaalt of de gebruiker nog actief is.
  global $db;
      try {
          $data = $db->prepare("select ACTIEF from WERKNEMER where WERKNEMERID = ?"); 
          $data->execute(array($gebruiker));
          $result = $data->fetch();
          if($result["ACTIEF"] == 1){           
              return true;                     
          }
          return false;
         } 
      catch (PDOException $e) {
          echo "ERROR, ".$e->getMessage();
      } 
}

function controleerActief($gebruiker){
  //Controleert of de gebruiker nog als actief wordt beschouwd.
  if(!isActief($gebruiker)){
    uitloggen();
  }
}


function checkInlog($gebruiker, $wachtwoord){
  //Controleert of de ingevoerde gegevens kloppen met de database.
  if(is_numeric($gebruiker)){
    global $db;
      try {
          $data = $db->prepare("select WACHTWOORD from WERKNEMER where WERKNEMERID = ?"); 
          $data->execute(array($gebruiker));
          $result = $data->fetch();
          if(isActief($gebruiker)){
            if(password_verify($wachtwoord,$result["WACHTWOORD"])){
              return true;
            }            
          }
          return false;
         } 
      catch (PDOException $e) {
          echo "ERROR, ".$e->getMessage();
      } 
    }
}

function inloggen($gebruiker){
  $_SESSION["WerknemerID"] = $gebruiker; 
  $_SESSION["Admin"] = checkAdmin($gebruiker);
  header('Location: index.php');
  exit;
}

function checkAdmin($gebruiker){
  //Controleert of de gebruiker een admin is.
 global $db;
      try {
          $data = $db->prepare("select WERKNEMERID from ADMIN where WERKNEMERID = ?"); 
          $data->execute(array($gebruiker));
          $result = $data->fetch();
             
          if(isset($result["WERKNEMERID"])){
            return true;
          }
          else {
          return false;
          }
       }
      catch (PDOException $e) {
          echo "ERROR, ".$e->getMessage();
      } 
}



function getGebruikerNamen($gebruiker){
  //Haalt de voornaam en achternaam van de werknemer op.
 global $db;
  try {
     $data = $db->prepare("select VOORNAAM, ACHTERNAAM from WERKNEMER where WERKNEMERID = ?"); 
        $data->execute(array($gebruiker));
        $result = $data->fetch();
        
        return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    } 
}

function getArrondissementEnStationnummer($stationID){
  global $db;
  try {
     $data = $db->prepare("select STATIONNUMMER, ARRONDISSEMENT from STATION where STATIONID = ?"); 
        $data->execute(array($stationID));
        $result = $data->fetch();       
        return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getMonteurDienstPerWeek($WerknemerID, $StartDate, $EndDate){
  //Geeft voor een week het dienstrooster van de monteur.
  global $db;
  try {
     $data = $db->prepare("SELECT WORKSHOPID,START_DATUM, cast(EIND_TIJD as time(0)) [EIND_TIJD]
                          FROM MONTEURDIENST 
                          WHERE WERKNEMERID = ? 
                          AND CONVERT(DATETIME, FLOOR(CONVERT(FLOAT, START_DATUM))) >= ?
                          AND CONVERT(DATETIME, FLOOR(CONVERT(FLOAT, START_DATUM))) <= ?"); 
        $data->execute(array($WerknemerID, $StartDate, $EndDate));
        $result = $data->fetchall();       
        return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}


function GetTeamIdVanWerknemer($WerknemerID){
  //Geeft het team ID van de werknemer.
  global $db;
  try {
     $data = $db->prepare("	SELECT TEAMID
                          FROM dbo.WERKNEMER
                          WHERE WERKNEMERID = ?"); 
        $data->execute(array($WerknemerID));
        $result = $data->fetch(); 
        
        if(!empty($result)){      
        return $result["TEAMID"];
        } else {
        return false;
        }
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

 
 
function getStartAndEndDate($week, $year){
  //Geeft de eerste en de laaste datum van de opgegeven week.
  $dto = new DateTime();
  $dto->setISODate($year, $week);
  $ret['week_start'] = $dto->format('Y-m-d');
  $dto->modify('+6 days');
  $ret['week_end'] = $dto->format('Y-m-d');
  return $ret;
}

function getFietsenMoetGechecktworden(){
  //Geeft welke fietsen gecontroleerd moeten worden.
    global $db;
  try {
     $data = $db->prepare("select * from FIETSPOST f inner join station s on s.STATIONID = f.STATIONID where       MOETGECHECKTWORDEN = 1 order by arrondissement, stationnummer, fietspostid"); 
        $data->execute();
        $result = $data->fetchall();       
        return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function toonFietsen(){
  //Laat alle fietsen zien in een station.
  global $db;
  try{
    $data = $db->prepare("select top 10 * from FIETSPOST f inner join station s on s.STATIONID = f.STATIONID where MOETGECHECKTWORDEN = 1 order by arrondissement, stationnummer, fietspostid"); 
    $data->execute();
    foreach($data as $rij){
      echo '<tr>';
      echo '<td>'.$rij["FIETSID"].'</td>';
      echo '<td>'.$rij["ARRONDISSEMENT"].'</td>';
      echo '<td>'.$rij["STATIONNUMMER"].'</td>';
      echo '<td>'.$rij["FIETSPOSTID"].'</td>';
      echo '</tr>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function toonReparatieQueue($workshopID){
  //Laat de reparatiequeue zien.
  global $db;
  try{
    $data = $db->prepare("select FIETSID, VOLGNUMMER, WORDT_GEREPAREERD from REPARATIEQUEUE where workshopid = ?"); 
    $data->execute(array($workshopID));
    foreach($data as $rij){
      echo '<tr>';
      echo '<td><a href="reparatie.php?Workshop=' . $workshopID . '&fietsnummer='.$rij["FIETSID"].'">'.$rij["FIETSID"].'</a></td>';
      echo '<td>'.$rij["VOLGNUMMER"].'</td>';
      if($rij["WORDT_GEREPAREERD"] == 1){
        echo '<td>Ja</td>';
      } else {
        echo '<td>Nee</td>';
      }      
      echo '</tr>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function getRoutingCard($TeamID, $Datum){
  //Geeft de routingcard van een team op de gegeven datum)
 global $db;
 try {
   $data = $db->prepare("SELECT S.ARRONDISSEMENT, S.STATIONNUMMER, FP.FIETSPOSTID, FP.FIETSID, RC.RITDATUM  
    FROM dbo.ROUTINGCARD RC INNER JOIN dbo.FIETSPOST FP ON FP.STATIONID = RC.STATIONID
    INNER JOIN dbo.STATION S ON S.STATIONID = FP.STATIONID
    WHERE FP.MOETGECHECKTWORDEN = 1 AND RC.TEAMID = ? AND CONVERT(DATETIME, FLOOR(CONVERT(FLOAT, RC.RITDATUM))) = ?
    ORDER BY S.ARRONDISSEMENT, S.STATIONNUMMER");
   $data->execute(array($TeamID, $Datum));
   $result = $data->fetchall();       
   return $result;
 }
 catch (PDOException $e) {
  echo "ERROR, ".$e->getMessage();
}
}

function getAantalWorkshops(){
  //Geeft het aantal workshops.
 global $db;
      try {
          $data = $db->prepare("select * from workshop"); 
          $data->execute();
          $result = $data->fetchall();
          return count($result);
       }
      catch (PDOException $e) {
          echo "ERROR, ".$e->getMessage();
      } 
}

function workshopSelect($paginaNaam, $huidigeWorkshop){
  //Laat de workshops zien in een keuzemenu
  $aantalWorkshops = getAantalWorkshops();
  for($x=1; $x<=$aantalWorkshops; $x++){
    echo '<option value="'.$paginaNaam.'.php?Workshop='.$x.'"';
    if ($x == $huidigeWorkshop){
      echo 'selected';
    }
    echo '>Workshop '.$x.'</option>';
  }
}

function wordRepareren($fietsID){
  //Hiermee kun je aangeven dat een fiets gerepareerd wordt.
 global $db;
    try{
     $data = $db->prepare("exec spPakFietsOmTeRepareren @FIETSID = ?"); 
     $data->execute(array($fietsID));
     return $data;
    }
    catch(PDOException $e) {
       $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function controleerInBestelling($workshopID, $onderdeelID){
  global $db;
      try {
          $data = $db->prepare("select count(*) from bestelling where AANGEKOMEN = 0 and workshopid=? and onderdeelid=? "); 
          $data->execute(array($workshopID, $onderdeelID));
          $result = $data->fetch();
          if($result[0]>0){                              
            return true;
          }
          else{
            return false;
          }
       }
      catch (PDOException $e) {
          echo "ERROR, ".$e->getMessage();
      } 
}

function toonBestelLijst($workshopID, $isAdminLijst){
  global $db;
  try{
    $data = $db->prepare("select * from bestelling b inner join fietsonderdeel fo on b.onderdeelid=fo.onderdeelid where WORKSHOPID = ?"); 
    $data->execute(array($workshopID));
    foreach($data as $rij){
      echo '<tr>';
      echo '<td>'.$rij["ORDERID"].'</td>';
      echo '<td>'.$rij["ONDERDEELID"].'</td>';
      echo '<td>'.$rij["NAAM"].'</td>';
      echo '<td>'.$rij["AANTAL"].'</td>';
      if ($isAdminLijst){
        echo '<form action="" method="post">
        <td>
        <input type="hidden" name="bestellingBinnengekomen" value="'.$rij['ORDERID'].'">
        <input class="ui fluid small teal submit button" type="submit" class="button" value="Binnengekomen">
        </td>
        </form>
        <form action="" method="post">
        <td>
        <input type="hidden" name="bestellingVerwijderen" value="'.$rij['ORDERID'].'">
        <input class="ui fluid small teal submit button" type="submit" class="button" value="Verwijderen">
        </td>
        </form>';
      }
      echo '</tr>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function convertDag($dag){
  //Dagen worden in het Engels gegeven, deze functie zorgt ervoor dat de namen worden aangepast naar de Nederlandse namen.
  if ($dag == 'Monday'){
    return 'Maandag';
  }
  else if ($dag == 'Tuesday') {
    return 'Dinsdag';
  }
  else if ($dag == 'Wednesday') {
    return 'Woensdag';
  }
  else if ($dag == 'Thursday') {
    return 'Donderdag';
  }
  else if ($dag == 'Friday') {
    return 'Vrijdag';
  }
  else if ($dag == 'Saturday') {
    return 'Zaterdag';
  }
  else if ($dag == 'Sunday') {
    return 'Zondag';
  }
  else {
    return '-';
  }
}

function verwijderOrder($orderID){
  global $db;
      try {
          $data = $db->prepare("exec spBestellingVerwijderen @id = ?"); 
          $data->execute(array($orderID));
          toonSucces("De bestelling is verwijderd.");
       }
      catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
      } 
}

function markeerBestellingBinnengekomen($orderID){
  global $db;
      try {
          // $data = $db->prepare("update bestelling set aangekomen=1 where orderid=?"); 
          $data = $db->prepare("exec spBestellingKomtBinnen @orderID = ?");
          $data->execute(array($orderID));
          toonSucces("De bestelling is gemarkeerd als binnengekomen.");
       }
      catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
      } 
}





function toonInventaris($workshopID){
  global $db;
  try{
    $data = $db->prepare("select * from fietsonderdeel f inner join FIETSONDERDEELINWORKSHOP fiw on f.ONDERDEELID = fiw.ONDERDEELID where workshopid = ?"); 
    $data->execute(array($workshopID));
    foreach($data as $rij){
      $teWeinig = false;
      // $inBestelling = controleerInBestelling($workshopID,$rij["ONDERDEELID"]);
      $inBestelling = false;
      if($rij["AANTAL"]<$rij["MINIMAAL_AANTAL"]){
        $teWeinig = true;
      }
      echo '<tr>';
      echo '<td>'.$rij["ONDERDEELID"].'</td>';
      echo '<td>'.$rij["NAAM"].'</td>';
      echo '<td>';
      if ($teWeinig){
        if ($inBestelling){
          echo '<i class="yellow cart icon"></i>';
        }
        else{
          echo '<i class="red attention icon"></i>';
        }
      }
      echo $rij["AANTAL"].'</td>';
      echo '<td>';
      if ($teWeinig){
        if ($inBestelling){
          echo '<i class="yellow cart icon"></i>';
        }
        else{
          echo '<i class="red attention icon"></i>';
        }
      }
      echo $rij["MINIMAAL_AANTAL"].'</td>';
      echo '<form action="" method="post">
      <td>
      <div class="ui mini input"><input type="text" name="nieuwInventaris" placeholder="Aantal meer/minder"></div>
      <input type="hidden" name="onderdeelID" value="'.$rij["ONDERDEELID"].'">
      <input class="ui small teal submit button" type="submit" class="button" name="aanpassenInventarisPlus" value="+">
      <input class="ui small teal submit button" type="submit" class="button" name="aanpassenInventarisMin" value="-">
      </td>
      </form> 
      <form action="" method="post">
      <td>
      <div class="ui mini input"><input type="text" name="aantalTeBestellen" placeholder="Aantal"></div>
      <input type="hidden" name="onderdeelID" value="'.$rij["ONDERDEELID"].'">
      <input class="ui fluid small teal submit button" type="submit" class="button" name="toevoegenLijst" value="Bestellen">
      </td>
      </form>';
      echo '</tr>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function getWerknemers(){
  global $db;
    try {
   $data = $db->prepare("SELECT WERKNEMERID, VOORNAAM, ACHTERNAAM
                        FROM dbo.WERKNEMER
                        ORDER BY WERKNEMERID");
   $data->execute();
   $result = $data->fetchall();       
   return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}



function getTeams(){
  global $db;
       try {
   $data = $db->prepare("SELECT TEAMID
                        FROM dbo.ONGROUNDTEAM
                        ORDER BY TEAMID");
   $data->execute();
   $result = $data->fetchall();       
   return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getWorkshops(){
  global $db;
       try {
   $data = $db->prepare("SELECT WORKSHOPID
                        FROM dbo.WORKSHOP
                        ORDER BY WORKSHOPID");
   $data->execute();
   $result = $data->fetchall();       
   return $result;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function checkWorkshop($WorkshopID){
  //Controleert of de workshop bestaat.
  global $db;
       try {
   $data = $db->prepare("SELECT WORKSHOPID FROM dbo.WORKSHOP WHERE WORKSHOPID = ?");
   $data->execute(array($WorkshopID));
   $result = $data->fetch();

   if($WorkshopID == $result['WORKSHOPID'] ){
    return true;
   } else {       
   return false;
   }
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }

}

function checkFietsNummer($Fietsnummer){
  //Controleert of het fietsnummer bestaat
  global $db;
       try {
   $data = $db->prepare("SELECT FIETSID
                        FROM dbo.FIETS
                        WHERE FIETSID = ?");
   $data->execute(array($Fietsnummer));
   $result = $data->fetch();

   if($Fietsnummer == $result['FIETSID'] ){
    return true;
   } else {       
   return false;
   }
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }

}


function checkFietsNummerOnGround($Fietsnummer){
  global $db;
       try {
   $data = $db->prepare("SELECT FIETSID
                        FROM dbo.FIETSPOST
                        WHERE FIETSID = ?");
   $data->execute(array($Fietsnummer));
   $result = $data->fetch();

   if($Fietsnummer == $result['FIETSID'] ){
    return true;
   }       
   return false;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }

}



function checkFietsNummerInQueue($Fietsnummer){
    global $db;
       try {
   $data = $db->prepare("SELECT FIETSID
                        FROM dbo.REPARATIEQUEUE 
                        WHERE FIETSID = ?");
   $data->execute(array($Fietsnummer));
   $result = $data->fetch();
   if($Fietsnummer == $result['FIETSID']){
    return true;
   }       
   return false;
  }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getAlleOnderdelen(){
       global $db;
       try {
   $data = $db->prepare("SELECT ONDERDEELID, NAAM
                          FROM dbo.FIETSONDERDEEL");
   $data->execute(array());
   $result = $data->fetchall();
   return $result;
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getBeschrijvingVanQueue($fietsnummer){
global $db;
       try {
   $data = $db->prepare("SELECT BESCHRIJVING
                        FROM dbo.REPARATIEQUEUE
                        WHERE FIETSID = ? ");
   $data->execute(array($fietsnummer));
   $result = $data->fetch();
   return $result['BESCHRIJVING'];
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function checkOnderdelen($onderdelen){
  //Controleer meerdere onderdelen
  foreach($onderdelen as $onderdeel){
    if(!checkOnderdeel($onderdeel)){
      return false;
    }
  
  }
  return true;
}


function checkOnderdeel($onderdeelID){
  global $db;
       try {
   $data = $db->prepare("SELECT ONDERDEELID
                          FROM dbo.FIETSONDERDEEL
                          WHERE ONDERDEELID = ? ");
   $data->execute(array($onderdeelID));
   $result = $data->fetch();
   if($onderdeelID == $result['ONDERDEELID']){
    return true;
    } else {
   return false;
    }
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}
function insertReparatie($workshopID, $fietsnummer, $onderdelen, $werknemerID){
global $db;
    try{
     foreach($onderdelen as $row){  
     $data = $db->prepare("exec spVoegReparatieToe @WORKSHOPID = ?, @FIETSID = ?, @ONDERDEELID = ?, @WERKNEMERID  = ?"); 
     $data->execute(array($workshopID, $fietsnummer,$row,$werknemerID)); 
     }
      return true;
    }
    catch (PDOException $e) {
         $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function getVervangdeOnderdelen($fietsnummer){
  global $db;
       try {
   $data = $db->prepare("SELECT ONDERDEELID, CONVERT(date,REPARATIE_DATUM) as 'REPARATIE_DATUM'
                          FROM dbo.REPARATIE
                          WHERE FIETSID = ?
                          ORDER BY REPARATIE_DATUM DESC");
   $data->execute(array($fietsnummer));
   $result = $data->fetchall();
    return $result;
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getOnderdeelNaam($onderdeelID){
   global $db;
       try {
   $data = $db->prepare("SELECT NAAM
                          FROM dbo.FIETSONDERDEEL
                          WHERE ONDERDEELID = ? ");
   $data->execute(array($onderdeelID));
   $result = $data->fetch();
    return $result['NAAM'];
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function checkInventarisVanWorkshop($workshopID, $onderdeelID){
      global $db;
       try {
   $data = $db->prepare("SELECT AANTAL  
                          FROM dbo.FIETSONDERDEELINWORKSHOP
                          WHERE WORKSHOPID = ? AND ONDERDEELID = ?");
   $data->execute(array($workshopID, $onderdeelID));
   $result = $data->fetchall();
    if($result[0][0] > 0){
     return true;
    } else { return false;}
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}


function terugInQueue($fietsID, $beschrijving){
 global $db;
    try{
     
     $data = $db->prepare("exec spFietsTerugInRepQueue @FIETSID = ?, @BESCHRIJVING = ?"); 
     $data->execute(array($fietsID, $beschrijving));
     return true;
    }
    catch (PDOException $e) {
         $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function fietsNaarOutqueue($fietsID, $workshopID){
   global $db;
    try{
     $data = $db->prepare("exec spFietsNaarOutqueue @FIETSID = ?, @WORKSHOP = ?"); 
     $data->execute(array($fietsID, $workshopID));
     return true;
    }
    catch (PDOException $e) {
         $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function getTaken(){
    global $db;
       try {
   $data = $db->prepare("SELECT *
                          FROM dbo.TAAK");
   $data->execute();
   $result = $data->fetchall();
    return $result;
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function getTaak($TaakID){
    global $db;
       try {
   $data = $db->prepare("SELECT TAAKNAAM
                          FROM dbo.TAAK
                          WHERE TAAKID = ?");
   $data->execute(array($TaakID));
   $result = $data->fetch();
    return $result[0];
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }

}


function geefSelectOptionsLeveranciers(){
  global $db;
  try{
    $data = $db->prepare("select * from LEVERANCIER order by NAAM asc"); 
    $data->execute();
    foreach($data as $rij){
      echo '<option value="'.$rij["LEVERANCIERID"].'">'.$rij["NAAM"].'</option>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function geefSelectOptionsOnderdelen(){
  global $db;
  try{
    $data = $db->prepare("select * from FIETSONDERDEEL order by NAAM asc"); 
    $data->execute();
    foreach($data as $rij){
      echo '<option value="'.$rij["ONDERDEELID"].'">'.$rij["NAAM"].'</option>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function inventarisBijwerken($workshop, $onderdeel, $aantal, $plusofmin){
 global $db;
    try{
    $werknemer = $_SESSION["WerknemerID"];
     $data = $db->prepare("exec spInventarisBijwerken @WERKNEMERID = ?, @ONDERDEELID = ?, @WORKSHOPID = ?, @AANTAL = ?, @PLUSOFMIN = ?"); 
     $data->execute(array($werknemer, $onderdeel, $workshop, $aantal, $plusofmin));
     return true;
    }
    catch (PDOException $e) {
          $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function onderdeelBestellen($workshop, $leverancier, $onderdeel, $aantal){
 global $db;
    try{
     $data = $db->prepare("exec spOnderdeelbestellen @workshop = ?, @leverancier = ?, @onderdeel = ?, @aantal = ?"); 
     $data->execute(array($workshop, $leverancier, $onderdeel, $aantal));
     return true;
    }
    catch (PDOException $e) {
         $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function getGoedkoopsteLeverancier($onderdeelid){
global $db;
       try {
   $data = $db->prepare("select top 1 * from FIETSONDERDEELBIJLEVERANCIER where onderdeelid = ? order by prijs asc");
   $data->execute(array($onderdeelid));
   $result = $data->fetch();
   return $result['LEVERANCIERID'];
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function fietsToevoegen($fietsid, $workshopid){
 global $db;
    try{
     $data = $db->prepare("exec spFietsToevoegen @fietsid = ?, @workshopid = ?"); 
     $data->execute(array($fietsid, $workshopid));
     toonSucces('De fiets '.$fietsid.' is toegevoegd.');
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function toonError($message){
  //Toont een error die afkomt van de database.
  $errormsg = substr($message[2],54);
  echo '<div class="ui red message"><div class="header"></div><p>';
  echo $errormsg;
  echo '</p></div>';
}

function toonError2($message){
  //Toont een error die zelf is gemaakt.
  echo '<div class="ui red message"><div class="header"></div><p>';
  echo $message;
  echo '</p></div>';
}

function toonSucces($message){
  //Toont een succesform dat zelf is gemaakt.
  echo '<div class="ui green message"><div class="header"></div><p>';
  echo $message;
  echo '</p></div>';
}

function fietsVerwijderen($fietsid){
 global $db;
    try{
     $data = $db->prepare("exec spFietsVerwijderen @fietsid = ?"); 
     $data->execute(array($fietsid));
     toonSucces('Fiets '.$fietsid.' is verwijderd.');
     
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function controletaakToevoegen($taak){
 global $db;
    try{
     $data = $db->prepare("exec spControleTaakToevoegen @taak = ?"); 
     $data->execute(array($taak));
     toonSucces('De controletaak is toegevoegd.');
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function controletaakVerwijderen($taak){
 global $db;
    try{
     $data = $db->prepare("exec spControleTaakVerwijderen @taakid = ?"); 
     $data->execute(array($taak));
     toonSucces('De controletaak is verwijderd.');
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function geefSelectControleTaken(){
  //Laat de controletaken zien in een keuzemenu.
  global $db;
  try{
    $data = $db->prepare("select * from taak order by taaknaam asc"); 
    $data->execute();
    foreach($data as $rij){
      echo '<option value="'.$rij["TAAKID"].'">'.$rij["TAAKNAAM"].'</option>';
    }
  }
  catch (PDOException $e) {
    echo "ERROR, ".$e->getMessage();
  }
}

function onderdeelToevoegen($naam, $beschrijving, $max, $min){
 global $db;
    try{
     $data = $db->prepare("exec spOnderdeelToevoegen @naam = ?, @beschrijving = ?, @max = ?, @min = ?"); 
     if ($data->execute(array($naam, $beschrijving, $max, $min))){
      toonSucces($naam.' is toegevoegd als onderdeel.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function leverancierToevoegen($naam, $telefoon, $email){
 global $db;
    try{
     $data = $db->prepare("exec spLeverancierToevoegen @naam = ?, @telefoon = ?, @email = ?"); 
     if ($data->execute(array($naam, $telefoon, $email))){
      toonSucces($naam.' is toegevoegd als leverancier.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function koppelingToevoegen($onderdeel, $leverancier, $prijs){
 global $db;
 $prijs = str_replace(',', '.', $prijs);
    try{
     $data = $db->prepare("exec spKoppelOnderdeelAanLeverancier @onderdeel = ?, @leverancier = ?, @prijs = ?"); 
     if ($data->execute(array($onderdeel, $leverancier, $prijs))){
      toonSucces('De koppeling is toegevoegd.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function onderdeelVerwijderen($onderdeel){
 global $db;
    try{
     $data = $db->prepare("exec spOnderdeelVerwijderen @onderdeelid = ?"); 
     if ($data->execute(array($onderdeel))){
      toonSucces('Onderdeel '.$onderdeel.' is verwijderd.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function leverancierVerwijderen($leverancier){
 global $db;
    try{
     $data = $db->prepare("exec spLeverancierVerwijderen @leverancierid = ?"); 
     if ($data->execute(array($leverancier))){
      toonSucces('Leverancier '.$leverancier.' is verwijderd.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function koppelingVerwijderen($onderdeel, $leverancier){
 global $db;
    try{
     $data = $db->prepare("exec spVerwijderKoppelingOnderdeelBijLeverancier @ONDERDEEL = ?, @LEVERANCIER = ?"); 
     if ($data->execute(array($onderdeel, $leverancier))){
      toonSucces('De koppeling is verwijderd.');
     }
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}






function ongroundControle($fietsnummer,$Taken, $beschrijving, $werknemerID){
 global $db;
    try{
   
     foreach($Taken as $row){   
      $beschrijving = $beschrijving .','. getTaak($row);
     }
     $data = $db->prepare("exec spOngroundControle @fietsid = ?, @werknemerid = ?, @beschrijving = ?"); 
     $data->execute(array($fietsnummer, $werknemerID, $beschrijving));
     return true;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function naarWorkshop($fietsnummer, $workshopID, $beschrijving){
   global $db;
    try{
     $data = $db->prepare("exec spFietsNaarWorkshop @WORKSHOPID = ?, @FIETSID = ?, @BESCHRIJVING = ?"); 
     $data->execute(array($workshopID, $fietsnummer, $beschrijving));
     return true;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo();
       toonError($errorarray);
    }

}

function voegWerknemerToe($voornaam, $achternaam, $adres, $postcode, $wachtwoord){

    $hashedWachtwoord = password_hash($wachtwoord,1);
    
    global $db;
    try{
     $data = $db->prepare("exec spWerknemerToevoegen @VOORNAAM = ?, @ACHTERNAAM = ?, @ADRES = ?, @POSTCODE = ?, @WACHTWOORD = ?"); 
     $data->execute(array($voornaam, $achternaam, $adres, $postcode, $hashedWachtwoord));
     $id = $data->fetch();
     return $id[0];
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }

}

function ActiverenWerknemer($werknemerID){
  //Maakt een werknemer weer actief.
global $db;
    try{
     $data = $db->prepare("exec spToggleWerknemerActief @WERKNEMERID = ?"); 
     $data->execute(array($werknemerID));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }

}

function verwijderWerknemer($werknemerID){
global $db;
    try{
     $data = $db->prepare("exec spWerknemerVerwijderen @WERKNEMERID = ?"); 
     $data->execute(array($werknemerID));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }

}

function adminMaken($werknemerID){
global $db;
    try{
     $data = $db->prepare("exec spAdminToevoegen @WERKNEMERID = ?"); 
     $data->execute(array($werknemerID));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }

}

function roosterMonteurToevoegen($werknemerID, $startDatum, $workshopID, $eindTijd){
global $db;
    $startDatum = new DateTime($startDatum);
    $eindTijd = new DateTime($eindTijd);
    $startDatum = $startDatum->format('Y-m-d H:i:s');
    $eindTijd = $eindTijd->format('Y-m-d H:i:s');

    try{
     $data = $db->prepare("exec spRoosterMToevoegen @WERKNEMERID = ?, @START_DATUM = ?, @WORKSHOPID = ?, @EINDTIJD = ?"); 
     $data->execute(array($werknemerID, $startDatum, $workshopID, $eindTijd));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }

}

function werknemerInTeamToevoegen($werknemerID, $TeamID){
global $db;

    try{
     $data = $db->prepare("exec spZetWerknemerInTeam @werknemerid = ?, @teamid = ?"); 
     $data->execute(array($werknemerID, $TeamID));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function routingCard($teamID, $datum, $stationID){
  //Maakt een routingcard aan voor een bepaald team.
  global $db;
   $datum = new DateTime($datum);
   $datum = $datum->format('Y-m-d H:i:s');
   
    try{
     $data = $db->prepare("exec spRoutingCardToevoegen @team = ?, @ritdatum = ?, @station = ?"); 
     $data->execute(array($teamID, $datum, $stationID));
     return $data;
    }
    catch (PDOException $e) {
        $errorarray = $data->errorInfo(); 
        toonError($errorarray);
    }
}

function isInTeam($werknemerID){
  //Kijkt of een werknemer in een team zit.
  global $db;
       try {
   $data = $db->prepare("select teamID from WERKNEMER where werknemerid = ?");
   $data->execute(array($werknemerID));
   $result = $data->fetch();
   if ($result['teamID']>0){
      return true;
   }
   else {
      return false;
   }
   
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

function isInWorkshopTeam($werknemerID){
  global $db;
       try {
   $data = $db->prepare("select count(*) as dienst from monteurdienst where GETDATE() >= start_datum AND GETDATE() <= EIND_TIJD AND werknemerid = ?");
   $data->execute(array($werknemerID));
   $result = $data->fetch();
   if ($result['dienst']>0){
      return true;
   }
   else {
      return false;
   }
   
   }
    catch (PDOException $e) {
        echo "ERROR, ".$e->getMessage();
    }
}

// function checkWerknemerInTeam($werknemerID, $teamID){
// global $db;
//        try {
//    $data = $db->prepare("SELECT *
//                           FROM dbo.WERKNEMERINONGROUNDTEAM
//                           WHERE WERKNEMERID = ? AND TEAMID = ?");
//    $data->execute(array($werknemerID, $teamID));
//    $result = $data->fetch();
//     return $result[0];
//    }
//     catch (PDOException $e) {
//         echo "ERROR, ".$e->getMessage();
//     }
// }

function checkDatum($Datum){
  //Kijkt of de datum in de toekomst ligt.
$HuidigeDatum = new DateTime();
$HuidigeDatum = $HuidigeDatum->format('Y-m-d');
$Datum = new DateTime($Datum);
$Datum = $Datum->format('Y-m-d');
  if($Datum >= $HuidigeDatum){
    return true;
  } else {
    return false;
  }

}

function EventToevoegen($EventNaam, $Datum, $Tijd, $Beschrijving){
global $db;
   $datetime = $Datum . ' ' . $Tijd;
   $datetime = new DateTime($datetime);
   $datetime = $datetime->format('Y-m-d H:i');
       try {
   $data = $db->prepare("exec spSpeciaalEventToevoegen @EVENT_NAAM = ?, @DATUM = ?, @BESCHRIJVING = ?");
   $data->execute(array($EventNaam, $datetime,$Beschrijving ));
   return true;
   }
    catch (PDOException $e) {
    $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function getKomendeEvenementen(){
global $db;
   $date = new DateTime();
   $date = $date->format('Y-m-d');
    try {
   $data = $db->prepare("SELECT EVENTID, NAAM, DATUM FROM SPECIAAL_EVENEMENT WHERE DATUM >= ?");
   $data->execute(array($date));
   return $data;
   }
    catch (PDOException $e) {
     echo "ERROR, ".$e->getMessage();
    }

}

function stationAanEventToevoegen($EventID, $StationID){
 global $db;
       try {
   $data = $db->prepare("exec spStationVoorSpeciaalEvenementToevoegen @STATIONID = ?, @EVENTID = ?");
   $data->execute(array($StationID, $EventID));
   return true;
   }
    catch (PDOException $e) {
    $errorarray = $data->errorInfo();
       toonError($errorarray);
    }

}

function EvenementVerwijderen($EventID){
  global $db;
       try {
   $data = $db->prepare("exec spSpeciaalEventVerwijderen @EVENTID = ?");
   $data->execute(array($EventID));
   return true;
   }
    catch (PDOException $e) {
    $errorarray = $data->errorInfo();
       toonError($errorarray);
    }
}

function getStationsAanEvenement($EventID){
  global $db;

    try {
   $data = $db->prepare("SELECT STATIONID FROM STATION_IN_SPECIAAL_EVENEMENT WHERE EVENTID = ?");
   $data->execute(array($EventID));
   return $data;
   }
    catch (PDOException $e) {
     echo "ERROR, ".$e->getMessage();
    }

}

function StationAanEvenementVerwijderen($EventID, $StationID){
   global $db;
       try {
       
   $data = $db->prepare("exec spStationVoorSpeciaalEvenementVerwijderen @STATIONID = ?, @EVENTID = ?");
   $data->execute(array($StationID, $EventID));
   return true;
   }
    catch (PDOException $e) {
    $errorarray = $data->errorInfo();
       toonError($errorarray);
    }

}

 ?>

