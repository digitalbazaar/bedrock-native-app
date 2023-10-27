printf '<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <style>
      body {
        margin-top: env(safe-area-inset-top);
        margin-bottom: env(safe-area-inset-bottom);
        display: flex;
        align-items: center;
        flex-direction: column;
        gap: 25px;
        padding: 25px;
      }
      .row {
        display: flex;
        flex-direction: row;
        align-items: center;
      }
      .brand-name {
        font-weight: bold;
        font-size: 50px;
      }
    </style>
  </head>
  <body>
      <div class="row">
      <span class="brand-name">%s</span>
    </div>
    <h1>An error has occured.</h1>
    <h2>You may attempt to reload the site below.</h2>
    <a href="https://%s">Reload</a>
  </body>
</html>' $NATIVE_APP_NAME $NATIVE_APP_URL > ./www/applicationError.html

