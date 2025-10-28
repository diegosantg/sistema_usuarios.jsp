<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage=""%>
<%@ page import="org.apache.commons.fileupload.*, 
                 librerias.catalogos.*, 
                 librerias.base.*, 
                 librerias.comun.*, 
                 java.sql.*, java.util.*, java.io.File"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Detalle del Artista</title>
<link href="js/detalleArtista.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
</head>
<body bgproperties="fixed" topmargin="0" leftmargin="0">
<form action="" method="post" name="forma">

<%
    Resultados rs = null;
    int idArtista = Integer.parseInt(request.getParameter("id"));

    // Consulta para obtener los datos del artista
    String consultaArtista = 
        "SELECT UPPER(a.nombre) AS artista, " +
        "UPPER(n.nombre) AS nacionalidad, " +
        "UPPER(g.nombre) AS genero " +
        "FROM artistas a, nacionalidades n, generos g " +
        "WHERE a.cve_nacionalidades = n.cve_nacionalidades " +
        "AND a.cve_generos = g.cve_generos " +
        "AND a.cve_artistas = " + idArtista;

    rs = UtilDB.ejecutaConsulta(consultaArtista);

    String artista = "";
    String nacionalidad = "";
    String genero = "";

    if (rs.next()) {
        artista = rs.getString("artista");
        nacionalidad = rs.getString("nacionalidad");
        genero = rs.getString("genero");
    }
    rs.close();
%>

<!-- Mostrar los datos principales del artista -->
<table border="0" width="80%" align="center" cellspacing="10">
    <tr>
        <td colspan="2" align="center"><h2><%= artista %></h2></td>
    </tr>
    <tr>
        <td><b>Nacionalidad:</b></td>
        <td><%= nacionalidad %></td>
    </tr>
    <tr>
        <td><b>Genero:</b></td>
        <td><%= genero %></td>
    </tr>
</table>

<hr width="80%" />

<!-- Mostrar los discos del artista -->
<h3 align="center">Discos de <%= artista %>:</h3>

<table border="0" cellpadding="5" cellspacing="0" width="60%" align="center">
    <tr class="celdaEncabezado">
        <th>Nombre del Disco</th>
        <th>Ver Detalle</th>
    </tr>

<%
    // Consulta para obtener los discos del artista
    String consultaDiscos = 
        "SELECT d.cve_discos, UPPER(d.nombre) AS disco " +
        "FROM discos d " +
        "WHERE d.cve_artistas = " + idArtista + 
        " ORDER BY d.nombre";

    rs = UtilDB.ejecutaConsulta(consultaDiscos);
    int renglon = 0;
    String clase = "";

    while (rs.next()) {
        renglon++;
        clase = (renglon % 2 == 0) ? "textoCeldasChicas" : "textoCeldasChicas2";
%>
    <tr>
      <td class="<%= clase %>" data-label="Nombre del Disco"><%= rs.getString("disco") %></td>
<td class="<%= clase %>" data-label="Ver Detalle">
    <a href="detalleDisco.jsp?id=<%= rs.getInt("cve_discos")%>">Ver mas</a>
</td>

    </tr>
<%
    }
    rs.close();
%>
</table>

</form>
</body>
</html>
