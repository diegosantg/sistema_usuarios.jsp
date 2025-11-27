<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*, java.security.MessageDigest" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>INICIO DE SESION</title>
    <link href="js/diseno_login3.css" rel="stylesheet" type="text/css" />
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
        PreparedStatement psPerfil = null;
        ResultSet rs = null;
        ResultSet rsPerfil = null;

        try {
            con = UtilDB.getConnection();

            String sql = "SELECT * FROM usuarios WHERE correo = ? AND contrasena = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, contrasenaHash);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Usuario válido - Guardar datos en sesión
                int idUsuarioInt = rs.getInt("id_usuario"); // Mantener como int
                String nombreUsuario = rs.getString("nombre");
                
                // Convertir a Integer para la sesión
                Integer idUsuario = new Integer(idUsuarioInt);
                
                session.setAttribute("usuario", nombreUsuario);
                session.setAttribute("id_usuario", idUsuario);
                session.setAttribute("correo", correo);

                // Verificar si el usuario ya tiene perfil creado
                String sqlPerfil = "SELECT * FROM perfiles_usuario WHERE id_usuario = ?";
                psPerfil = con.prepareStatement(sqlPerfil);
                psPerfil.setInt(1, idUsuarioInt); // Usar el int original aquí
                rsPerfil = psPerfil.executeQuery();

                if (rsPerfil.next()) {
                    // Usuario YA TIENE perfil - Redirigir al dashboard
                    out.println("<script>alert('Inicio de sesión correcto, bienvenido " + nombreUsuario + "'); window.location='dashboard.jsp';</script>");
                } else {
                    // Usuario NO TIENE perfil - Redirigir a crear perfil
                    out.println("<script>alert('Inicio de sesión correcto, completa tu perfil'); window.location='crearPerfil.jsp?id_usuario=" + idUsuarioInt + "';</script>");
                }

            } else {
                // Usuario o contraseña incorrectos
                out.println("<script>alert('Correo o contraseña incorrectos'); history.back();</script>");
            }

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
        } finally {
            if (rsPerfil != null) try { rsPerfil.close(); } catch (Exception ex) {}
            if (psPerfil != null) try { psPerfil.close(); } catch (Exception ex) {}
            if (rs != null) try { rs.close(); } catch (Exception ex) {}
            if (ps != null) try { ps.close(); } catch (Exception ex) {}
            if (con != null) try { con.close(); } catch (Exception ex) {}
        }
    }
%>

    <div class="login-container">
        <a href="inicio.jsp"> <img class="logo" src="img/image.png" alt="logo"></a>
        <h2>Iniciar Sesión</h2>

        <form method="post">
            <input type="email" name="correo" placeholder="Correo" required>
            <div class="password-container">
                <input type="password" name="password" id="password" placeholder="Contraseña" required>
                <span class="toggle-password" onclick="togglePassword()"></span>
            </div>

            <div class="¿Olvidaste">
                ¿Olvidaste tu contraseña? <a href="recovery.jsp">Recupérala aquí</a>
            </div>
            <button type="submit">Entrar</button>
            
            <div class="registro-link">
                ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
            </div>
        </form>
    </div>

<script>
function togglePassword() {
    const passwordInput = document.getElementById("password");
    const toggleIcon = document.querySelector(".toggle-password");
    
    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        toggleIcon.classList.add("hide");
    } else {
        passwordInput.type = "password";
        toggleIcon.classList.remove("hide");
    }
}
</script>

</body>
</html>