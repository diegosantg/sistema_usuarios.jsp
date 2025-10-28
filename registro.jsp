<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*, java.security.MessageDigest" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="iso-8859-1">
    <title>REGISTRO DE USUARIO</title>
    <link href="js/cssregistro.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body bgproperties="fixed" topmargin="0" leftmargin="0">

<%
    // --- Detectar si el formulario fue enviado ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            out.println("<script>alert('Las contraseñas no coinciden'); history.back();</script>");
        } else {
            // --- Encriptar contraseña con SHA-256 (compatible con Tomcat 5) ---
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

            try {
                con = UtilDB.getConnection();

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
                if (ps != null) try { ps.close(); } catch (Exception ex) {}
                if (con != null) try { con.close(); } catch (Exception ex) {}
            }
        }
    } // fin del if POST
%>

    <div class="login-container">
        <a href="inicio.jsp"><img class="logo" src="img/logo_enerkoi2.0.png" alt="logo"></a>
        <h2>Registro de Usuario</h2>

        <form method="post" onsubmit="return validarContrasenas()">
            <input type="text" name="nombre" placeholder="Nombre" required>
            <input type="text" name="apellidoPaterno" placeholder="Apellido Paterno" required>
            <input type="text" name="apellidoMaterno" placeholder="Apellido Materno" required>
            <input type="email" name="correo" placeholder="Correo Electronico" required>
            <input type="password" id="password" name="password" placeholder="Contrasena" required>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirmar Contrasena" required>

            <div id="msg" style="color:#ffdddd; margin-bottom:12px; font-size:0.9rem;"></div>

            <button type="submit">Registrarse</button>

            <div class="¿Olvidaste">
                Ya tienes cuenta? <a href="login.jsp">Inicia Sesion</a>
            </div>
        </form>
    </div>

    <script>
        function validarContrasenas() {
            const pass = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const msg = document.getElementById('msg');
            
            if (pass !== confirm) {
                msg.textContent = 'Las contraseñas no coinciden.';
                return false;
            } else {
                msg.textContent = '';
                return true;
            }
        }
    </script>
</body>
</html>
