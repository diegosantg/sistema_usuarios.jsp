<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*, java.security.MessageDigest" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>REGISTRO DE USUARIO</title>
    <link href="js/registro2.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body bgproperties="fixed" topmargin="0" leftmargin="0">

<%
    // --- Detectar si el formulario fue enviado ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Configurar encoding UTF-8 para los parámetros
        request.setCharacterEncoding("UTF-8");
        
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
            // --- Encriptar contraseña con SHA-256 ---
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
            PreparedStatement ps2 = null;
            ResultSet rs = null;

            try {
                con = UtilDB.getConnection();

                // INSERT en tabla usuarios
                String sql = "INSERT INTO usuarios (nombre, apellido_paterno, apellido_materno, correo, contrasena) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);

                ps.setString(1, nombre);
                ps.setString(2, apellidoPaterno);
                ps.setString(3, apellidoMaterno);
                ps.setString(4, correo);
                ps.setString(5, contrasenaHash);

                int filas = ps.executeUpdate();

                if (filas > 0) {
                    // Obtener el id_usuario recién insertado
                    ps2 = con.prepareStatement("SELECT id_usuario FROM usuarios WHERE correo = ? ORDER BY id_usuario DESC LIMIT 1");
                    ps2.setString(1, correo);
                    rs = ps2.executeQuery();
                    
                    if (rs.next()) {
                        int idUsuario = rs.getInt("id_usuario");
                        // Redirigir a la página de creación de perfil
                        response.sendRedirect("crearPerfil.jsp?id_usuario=" + idUsuario);
                    } else {
                        out.println("<script>alert('Error al obtener ID del usuario'); history.back();</script>");
                    }
                } else {
                    out.println("<script>alert('Error al registrar el usuario'); history.back();</script>");
                }

            } catch (SQLException e) {
                if (e.getErrorCode() == 1062) { // Código de error para duplicados en MySQL
                    out.println("<script>alert('El correo electrónico ya está registrado'); history.back();</script>");
                } else {
                    out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
                }
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ex) {}
                if (ps != null) try { ps.close(); } catch (Exception ex) {}
                if (ps2 != null) try { ps2.close(); } catch (Exception ex) {}
                if (con != null) try { con.close(); } catch (Exception ex) {}
            }
        }
    } // fin del if POST
%>

    <div class="login-container">
        <a href="inicio.jsp"><img class="logo" src="img/logo_enerkoi2.0.png" alt="logo"></a>
        <h2>Registro de Usuario</h2>

        <form method="post" onsubmit="return validarContrasenas()" accept-charset="UTF-8">
            <input type="text" name="nombre" placeholder="Nombre" required>
            <input type="text" name="apellidoPaterno" placeholder="Apellido Paterno" required>
            <input type="text" name="apellidoMaterno" placeholder="Apellido Materno" required>
            <input type="email" name="correo" placeholder="Correo Electrónico" required>
            
            <!-- Campo de Contraseña con ícono -->
            <div class="password-container">
                <input type="password" id="password" name="password" placeholder="Contraseña" required>
                <span class="toggle-password" onclick="togglePassword('password')"></span>
            </div>
            
            <!-- Campo de Confirmar Contraseña con ícono -->
            <div class="password-container">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirmar Contraseña" required>
                <span class="toggle-password" onclick="togglePassword('confirmPassword')"></span>
            </div>

            <div id="msg" style="color:#ffdddd; margin-bottom:12px; font-size:0.9rem;"></div>

            <button type="submit">Registrarse</button>

            <div class="¿Olvidaste">
                ¿Ya tienes cuenta? <a href="login.jsp">Inicia Sesión</a>
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

        function togglePassword(passwordId) {
            const passwordInput = document.getElementById(passwordId);
            const toggleIcon = document.querySelector(`[onclick="togglePassword('${passwordId}')"]`);
            
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