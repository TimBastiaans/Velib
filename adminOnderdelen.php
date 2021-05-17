  <?php   
	// HTML/CSS door: Marco Schattevoet (517538) 
	parse_str($_SERVER['QUERY_STRING']);

  include 'includes/header.php';
  
  if (!$admin){
    header('Location: index.php');
    exit;
  }
  

?>

<div class="ui center aligned text container">

</div>

<div class="ui grid">
  <div class="one wide column"></div>
  <div class="five wide column">
    <h1>Onderdeel toevoegen</h1>
    <?php
    if (isset($_POST["OnderdeelToevoegen"])){
      if(!empty($_POST["Naam"]) && !empty($_POST["MinimaalAantal"]) && !empty($_POST["MaximaalAantal"])){
        if(is_numeric($_POST["MinimaalAantal"]) && is_numeric($_POST["MaximaalAantal"])){
        onderdeelToevoegen($_POST["Naam"], $_POST["Beschrijving"],$_POST["MinimaalAantal"],$_POST["MaximaalAantal"]);
          } else {toonError2("Minimaal en maximaal aantal moet een nummer zijn.");}
        } else {toonError2("Een van de velden is niet ingevuld.");}
      }
    ?>
    <form action="" method="post">
      <div class="ui form">
        	<div class="field">		
        			<label>Naam:</label>
        			<input type="text" name="Naam"/>
        	</div>
          <div class="field">		
        			<label>Beschrijving optioneel:</label>
        			<textarea rows="3" name="Beschrijving"></textarea>
        	</div>
          <div class="field">		
        			<label>Minimaal aantal:</label>
        			<input type="text" name="MinimaalAantal"/>
        	</div>
           <div class="field">		
        			<label>Maximaal aantal:</label>
        			<input type="text" name="MaximaalAantal"/>
        	</div>         
          <input class="ui large teal submit button" type="submit" class="button" name="OnderdeelToevoegen" value="Toevoegen">
        </div>
    </form> 
  </div>
  
  <div class="five wide column">
    <h1>Leverancier toevoegen</h1>
    <?php
    if (isset($_POST["LeverancierToevoegen"])){
      if(!empty($_POST["Naam"])){
          leverancierToevoegen($_POST["Naam"], $_POST["Telefoonnummer"],$_POST["Email"]);
        } else {toonError2("De naam van de leverancier is niet ingevuld.");}
      }
    ?>
    <form action="" method="post">
      <div class="ui form">
        	<div class="field">		
        			<label>Naam:</label>
        			<input type="text" name="Naam"/>
        	</div>
          <div class="field">		
        			<label>Telefoonnummer optioneel:</label>
        			<input type="text" name="Telefoonnummer"/>
        	</div>
           <div class="field">		
        			<label>Email optioneel:</label>
        			<input type="text" name="Email"/>
        	</div>
          <input class="ui large teal submit button" type="submit" class="button" name="LeverancierToevoegen" value="Toevoegen">
        </div>
    </form>
  </div>
  
  <div class="five wide column">
    <h1>Onderdeel bij leverancier</h1>
    <?php
    if (isset($_POST["OnderdeelBijLeverancier"])){
      if(!empty($_POST["koppelingOnderdeel"]) && !empty($_POST["koppelingLeverancier"]) && !empty($_POST["Prijs"])){
        if(is_numeric($_POST["Prijs"])){
        $_POST["Prijs"] = floatval($_POST["Prijs"]);
        koppelingToevoegen($_POST["koppelingOnderdeel"],$_POST["koppelingLeverancier"],$_POST["Prijs"]);
          } else {toonError2("De prijs moet een nummer zijn.");}
        } else {toonError2("Een van de velden is niet ingevuld.");}
      }
    ?>
    <form action="" method="post">
      <div class="ui form">
       <div class="field">    
       <label>Onderdeel:</label>
       <select class="ui search selection dropdown search-select" name=koppelingOnderdeel>
          <option value="">Onderdeel</option>
          <<?php geefSelectOptionsOnderdelen(); ?>
         </select>
     </div>
       <div class="field">		
         <label>Leverancier:</label>
         <select class="ui search selection dropdown search-select" name=koppelingLeverancier>
          <option value="">Leverancier</option>
          <<?php geefSelectOptionsLeveranciers(); ?>
         </select>
      </div>


      
     <div class="field">		
       <label>Prijs:</label>
       <input type="text" name="Prijs"/>
     </div>
     <input class="ui large teal submit button" type="submit" class="button" name="OnderdeelBijLeverancier" value="Toevoegen">
   </div>
 </form>
</div>
  
  <div class="one wide column"></div>
  <div class="five wide column">
    <h1> Onderdeel Verwijderen </h1>
    <?php
    if (isset($_POST["verwijderKnopOnderdeel"])){
        onderdeelVerwijderen($_POST["OnderdeelID"]);
      }
    ?>
    <form action="" method="post" class="ui form">
      <div class="field">   
        <label>Onderdeel:</label>
        <select class="ui search selection dropdown search-select" name=OnderdeelID>
          <option value="">Onderdeel</option>
          <<?php geefSelectOptionsOnderdelen(); ?>
        </select>
      </div>
      <br>
      <input class="ui fluid large teal submit button" type="submit" class="button" name="verwijderKnopOnderdeel" value="Verwijderen">
    </form>
  </div>
  
  <div class="five wide column">
    <h1> Leverancier Verwijderen </h1>
    <?php
    if (isset($_POST["verwijderKnopLeverancier"])){
        leverancierVerwijderen($_POST["LeverancierID"]);
      }
    ?>
    <form action="" method="post" class="ui form">
      <div class="field">   
        <label>Leverancier:</label>
        <select class="ui search selection dropdown search-select" name=LeverancierID>
          <option value="">Leverancier</option>
          <<?php geefSelectOptionsLeveranciers(); ?>
        </select>
      </div>
      <br>
      <input class="ui fluid large teal submit button" type="submit" class="button" name="verwijderKnopLeverancier" value="Verwijderen">
    </form>
  </div>
  
  <div class="five wide column">
    <h1>Onderdeel bij leverancier</h1>
    <?php
    if (isset($_POST["VerwijderOnderdeelBijLeverancier"])){
        koppelingVerwijderen($_POST["koppelingOnderdeel"],$_POST["koppelingLeverancier"]);
      }
    ?>
    <form action="" method="post">
      <div class="ui form">
       <div class="field">    
         <label>Onderdeel:</label>
         <select class="ui search selection dropdown search-select" name=koppelingOnderdeel>
          <option value="">Onderdeel</option>
          <<?php geefSelectOptionsOnderdelen(); ?>
        </select>
      </div>
      <div class="field">    
       <label>Leverancier:</label>
       <select class="ui search selection dropdown search-select" name=koppelingLeverancier>
        <option value="">Leverancier</option>
        <<?php geefSelectOptionsLeveranciers(); ?>
      </select>
    </div>
    <input class="ui large teal submit button" type="submit" class="button" name="VerwijderOnderdeelBijLeverancier" value="Verwijderen">
  </div>
</form>
</div>

<script>
$('.search-select')
  .dropdown()
;
</script>

<?php   
	include 'includes/footer.php';
?>