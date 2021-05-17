<?php   
// HTML/CSS door: Marco Schattevoet (517538) 
// PHP door: Marco Schattevoet (517538) en Jordi Stevens
include 'includes/header.php';

//Redirect naar index als je al ingelogd bent.
if ($huidigePagina == "inloggen.php"){
  if($login){
    header('Location: index.php');
    exit;
  }
}
$loginError = false;


//Inloggen
 if(isset($_POST['loginknop'])){
  if(checkInlog($_POST['werknemerID'],$_POST['password'])){
    inloggen($_POST['werknemerID']);
  }
  else {
    $loginError = true;
  }
} 

?>

<h3 class="ui center aligned header">Inloggen</h3>
<div class="ui text container">
  <?php if($loginError){
      echo '<b><i><font color="red">ERROR: U heeft een foutieve gebruikersnaam/wachtwoord ingevuld of uw account is niet actief.</font></i></b><br><br>';
  }
  ?>
  <form action="" method="post">
  <div class="ui segments">
          <div class="ui segment">WerknemerID:</div>
          <div class="ui segment field">
            <div class="ui fluid left icon input">
              <i class="user icon"></i>
              <input type="text" name="werknemerID" placeholder="WerknemerID">
            </div>
          </div>
          <div class="ui segment">Wachtwoord:</div>
          <div class="ui segment field">
            <div class="ui fluid left icon input">
              <i class="lock icon"></i>
              <input type="password" name="password" placeholder="Wachtwoord">
            </div>
          </div>
          <input class="ui fluid large teal submit button" type="submit" class="button" name="loginknop" value="Inloggen">
        </div>
    </form>
</div>

<?php   
	include 'includes/footer.php';
?>