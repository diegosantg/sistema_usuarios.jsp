<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*, java.security.MessageDigest" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>INICIO DE SESION</title>
    <link href="js/logincss.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body bgproperties="fixed" topmargin="0" leftmargin="0">

<%
    // --- Si el formulario fue enviado ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        // Encriptar contraseña ingresada con SHA-256 (igual que en el registro)
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < hash.length; i++) {
            int val = hash[i] & 0xff;
            if (val < 16) sb.append("0");
            sb.append(Integer.toHexString(val));
        }
        String contrasenaHash = sb.toString();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = UtilDB.getConnection();

            String sql = "SELECT * FROM usuarios WHERE correo = ? AND contrasena = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, contrasenaHash);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Usuario válido
                session.setAttribute("usuario", rs.getString("nombre"));
                out.println("<script>alert('Inicio de sesion correcto, bienvenido " + rs.getString("nombre") + "'); window.location='inicio.jsp';</script>");
            } else {
                // Usuario o contraseña incorrectos
                out.println("<script>alert('Correo o contrasena incorrectos'); history.back();</script>");
            }

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ex) {}
            if (ps != null) try { ps.close(); } catch (Exception ex) {}
            if (con != null) try { con.close(); } catch (Exception ex) {}
            
        }
    }
%>

    <div class="login-container">
        <a href="inicio.jsp"> <img class="logo" src="img/logo_enerkoi2.0.png" alt="logo"></a>
        <h2>Iniciar Sesion</h2>

        <form method="post">
            <input type="email" name="correo" placeholder="Correo" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <div class="¿Olvidaste">
                Olvidaste tu contrasena? <a href="recovery.jsp">Recuperala aqui</a>
            </div>
            <button type="submit">Entrar</button>
        </form>
    </div>

</body>
</html>
