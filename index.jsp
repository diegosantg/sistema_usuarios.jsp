<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>.: INDICE :.</title>
<link href="js/index.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
</head>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage=""%>
<%@ page import="org.apache.commons.fileupload.*, 
                 librerias.catalogos.*, 
				 librerias.base.*, 
				 librerias.comun.*, 
				 java.sql.*, java.util.*, java.io.File"%>
<%
/**
 * <p>Title: app_web</p>
 * <p>Description: Aplicaci�n Web para Nombre del Sistema</p>
 * <p>Copyright: Copyright (c) 20XX</p>
 * <p>Company: Nombre Compa��a </p>
 * @author Nombre del autor
 * @version 1.0
 */
%>
<script language="JavaScript">
</script>
<body bgproperties="fixed" topmargin="0" leftmargin="0" >
	<form action="" method="post" name="forma">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#FFFFFF" align="center">
						<%
						Resultados rs = null;
						String linea="SELECT a.cve_artistas , " +
               "UPPER(a.nombre) AS nombre, " +
               "UPPER(n.nombre) AS nacionalidad, " +
               "UPPER(g.nombre) AS genero " +
               "FROM artistas AS a, nacionalidades AS n, generos AS g " +
               "WHERE n.cve_nacionalidades = a.cve_nacionalidades " +
               "AND a.cve_generos = g.cve_generos " +
               "ORDER BY a.nombre";
						// Ejecuta la consulta
						rs = UtilDB.ejecutaConsulta(linea);
						int renglon=0;
						String clase="";
						String letra="";
						%>
                         <tr class="celdaEncabezado">
                           <th>  Artista</th>
                           <th>  Nacionalidad</th>
                           <th>  Genero</th>
                           <th>  Ver mas</th>
                           
                         </tr>
                        <%
						// Recorre el ResultSet
						while (rs.next())
						{
						
							renglon++;
							clase = renglon % 2 == 0 ? "textoCeldasChicas" : "textoCeldasChicas2";
						%>
						<tr>
							<td height="25" class="<%=clase%>">
								<%=rs.getString("nombre")%>
							</td> 
							<td height="25" class="<%=clase%>">
								<%=rs.getString("nacionalidad")%>
							</td> 
                            <td height="25" class="<%=clase%>">
								<%=rs.getString("genero")%>
							</td> 
							<td height="25" class="<%=clase%>">
								<a href="inicio.jsp?id=<%=rs.getInt("cve_artistas")%>">Ver mas</a> 
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
