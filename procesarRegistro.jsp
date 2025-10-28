<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*" %>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="iso-8859-1">
    <title>.: PROCESAR REGISTRO :.</title>
</head>
<body>
<%
   
    String nombre = request.getParameter("nombre");
    String apellidoPaterno = request.getParameter("apellidoPaterno");
    String apellidoMaterno = request.getParameter("apellidoMaterno");
    String correo = request.getParameter("correo");
String password = request.getParameter("password");


MessageDigest md = MessageDigest.getInstance("SHA-256");
byte[] hash = md.digest(password.getBytes("UTF-8"));


StringBuilder sb = new StringBuilder();
for (int i = 0; i < hash.length; i++) {
    int val = hash[i] & 0xff; // Convertir byte a entero positivo
    if (val < 16) sb.append("0"); // padding si es menor a 16
    sb.append(Integer.toHexString(val));
}
String contrasenaHash = sb.toString();


    Connection con = null;
    PreparedStatement ps = null;

    try {
        // Conexión usando librería
        con = UtilDB.getConnection();

        // Insertar datos
        String sql = "INSERT INTO usuarios (nombre, apellido_paterno, apellido_materno, correo, contrasena) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);

        ps.setString(1, nombre);
        ps.setString(2, apellidoPaterno);
        ps.setString(3, apellidoMaterno);
        ps.setString(4, correo);
       ps.setString(5, contrasenaHash); 


        int filas = ps.executeUpdate();

        if (filas > 0) {
            out.println("<script>alert('Usuario registrado correctamente'); window.location='login.jsp';</script>");
        } else {
            out.println("<script>alert('Error al registrar el usuario'); history.back();</script>");
        }

    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</body>
</html>
