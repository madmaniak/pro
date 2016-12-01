<?php

if ($_SERVER["REQUEST_URI"] == '/') {
  header('Location: http://localhost:8000/?pgsql=&username=' . getenv('pg_user') . '&db=' . getenv('app'));
  die();
}

function adminer_object() {

  include_once "./plugins/plugin.php";

  foreach (glob("plugins/*.php") as $filename) {
    include_once "./$filename";
  }

  $plugins = array(
    new AdminerJsonPreview
  );

  class AdminerCustomization extends AdminerPlugin {
    function name() {
      return getenv('app');
    }
    function credentials() {
      return array(getenv('pg_host') . ':' . getenv('pg_port'), getenv('pg_user'), getenv('pg_pass'));
    }
    function database() {
      return getenv('app');
    }
  }
  return new AdminerCustomization($plugins);
}

include "./adminer.php";

?>
