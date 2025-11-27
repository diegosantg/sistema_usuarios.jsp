<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="iso-8859-1">
    <title>ENERKOI GYM APP</title>
   <link href="js/inicio2.css" rel="stylesheet" type="text/css" />
<link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body bgproperties="fixed" topmargin="0" leftmargin="0">
    <%
        // Aquí podrías mantener tu lógica de conexión si lo requieres
        // Ejemplo:
        // Connection con = UtilDB.getConnection();
        // if (con != null) out.println("Conectado correctamente");
    %>

    <div class="container">
        <img src="img/image.png" alt="Logo del Sistema" class="logo">
          <h1>ENERKOI</h1>
            <p>Constante es mejor que Conforme</p>
        <div class="buttons">
            <form action="login.jsp" method="get">
                <button type="submit" class="btn">Iniciar Sesion</button>
            </form>
            <form action="registro.jsp" method="get">
                <button type="submit" class="btn">Registrarse</button>
            </form>
            <a href="quienessomos.html" class="help">Que es ENERKOI?</a>
        </div>
    </div>
</body>
</html>
