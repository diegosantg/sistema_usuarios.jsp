<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*" %>
<%
    // Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    
    if (usuario == null || idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Variables para mostrar datos del usuario
    String email = "";
    String fechaRegistro = "";
    String nivelExperiencia = "";
    String objetivo = "";
    
    // Cargar datos del usuario
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        con = UtilDB.getConnection();
        String sql = "SELECT u.email, u.fecha_registro, p.nivel_experiencia, p.objetivo " +
                    "FROM usuarios u LEFT JOIN perfiles_usuario p ON u.id = p.id_usuario " +
                    "WHERE u.id = ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            email = rs.getString("email");
            fechaRegistro = rs.getString("fecha_registro");
            nivelExperiencia = rs.getString("nivel_experiencia");
            objetivo = rs.getString("objetivo");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ajustes - ENERKOI</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="js/dashboard.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
    <style>
        .settings-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }

        .settings-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .settings-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #1a1a1a;
            border-bottom: 2px solid #FF3B3B;
            padding-bottom: 0.5rem;
        }

        .settings-item {
            display: flex;
            justify-content: between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .settings-item:last-child {
            border-bottom: none;
        }

        .settings-label {
            flex: 1;
            font-weight: 500;
            color: #333;
        }

        .settings-value {
            flex: 1;
            color: #666;
        }

        .settings-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .btn-edit, .btn-delete, .btn-logout {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background: #FF3B3B;
            color: white;
        }

        .btn-edit:hover {
            background: #e03535;
        }

        .btn-delete {
            background: #ff4757;
            color: white;
        }

        .btn-delete:hover {
            background: #ff3742;
        }

        .btn-logout {
            background: #6c757d;
            color: white;
        }

        .btn-logout:hover {
            background: #5a6268;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 2rem;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
            text-align: center;
        }

        .modal-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 1.5rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #FF3B3B;
            text-decoration: none;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .back-button:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="settings-container">
        <!-- Botón volver -->
        <a href="dashboard.jsp" class="back-button">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
            </svg>
            Volver al Dashboard
        </a>

        <h1 class="settings-title">⚙️ Ajustes de Cuenta</h1>

        <!-- Sección Información Personal -->
        <div class="settings-section">
            <h2>👤 Información Personal</h2>
            
            <div class="settings-item">
                <div class="settings-label">Nombre de Usuario</div>
                <div class="settings-value"><%= usuario %></div>
                <button class="btn-edit" onclick="editarUsuario()">Cambiar</button>
            </div>

            <div class="settings-item">
                <div class="settings-label">Email</div>
                <div class="settings-value"><%= email != null ? email : "No especificado" %></div>
                <button class="btn-edit" onclick="editarEmail()">Cambiar</button>
            </div>

            <div class="settings-item">
                <div class="settings-label">Contraseña</div>
                <div class="settings-value">••••••••</div>
                <button class="btn-edit" onclick="editarPassword()">Cambiar</button>
            </div>
        </div>

        <!-- Sección Perfil de Entrenamiento -->
        <div class="settings-section">
            <h2>💪 Perfil de Entrenamiento</h2>
            
            <div class="settings-item">
                <div class="settings-label">Nivel de Experiencia</div>
                <div class="settings-value">
                    <%= nivelExperiencia != null ? 
                        nivelExperiencia.substring(0,1).toUpperCase() + nivelExperiencia.substring(1) : 
                        "No especificado" %>
                </div>
                <button class="btn-edit" onclick="editarPerfil()">Editar</button>
            </div>

            <div class="settings-item">
                <div class="settings-label">Objetivo Principal</div>
                <div class="settings-value">
                    <%= objetivo != null ? 
                        objetivo.replace("_", " ").substring(0,1).toUpperCase() + objetivo.replace("_", " ").substring(1) : 
                        "No especificado" %>
                </div>
                <button class="btn-edit" onclick="editarPerfil()">Editar</button>
            </div>
        </div>

        <!-- Sección Preferencias -->
        <div class="settings-section">
            <h2>🎯 Preferencias</h2>
            
            <div class="settings-item">
                <div class="settings-label">Notificaciones</div>
                <div class="settings-value">Activadas</div>
                <button class="btn-edit" onclick="gestionarNotificaciones()">Gestionar</button>
            </div>

            <div class="settings-item">
                <div class="settings-label">Tema</div>
                <div class="settings-value">Claro</div>
                <button class="btn-edit" onclick="cambiarTema()">Cambiar</button>
            </div>

            <div class="settings-item">
                <div class="settings-label">Idioma</div>
                <div class="settings-value">Español</div>
                <button class="btn-edit" onclick="cambiarIdioma()">Cambiar</button>
            </div>
        </div>

        <!-- Sección Información de Cuenta -->
        <div class="settings-section">
            <h2>📊 Información de Cuenta</h2>
            
            <div class="settings-item">
                <div class="settings-label">ID de Usuario</div>
                <div class="settings-value"><%= idUsuario %></div>
            </div>

            <div class="settings-item">
                <div class="settings-label">Fecha de Registro</div>
                <div class="settings-value"><%= fechaRegistro != null ? fechaRegistro : "No disponible" %></div>
            </div>

            <div class="settings-item">
                <div class="settings-label">Miembro desde</div>
                <div class="settings-value">
                    <% 
                        if (fechaRegistro != null) {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                            java.util.Date regDate = sdf.parse(fechaRegistro);
                            java.util.Date now = new java.util.Date();
                            long diff = now.getTime() - regDate.getTime();
                            long days = diff / (1000 * 60 * 60 * 24);
                            out.print(days + " días");
                        } else {
                            out.print("No disponible");
                        }
                    %>
                </div>
            </div>
        </div>

        <!-- Sección Acciones Peligrosas -->
        <div class="settings-section">
            <h2>⚠️ Acciones Peligrosas</h2>
            
            <div class="settings-actions">
                <button class="btn-logout" onclick="cerrarSesion()">Cerrar Sesión</button>
                <button class="btn-delete" onclick="mostrarModalEliminar()">Eliminar Cuenta</button>
            </div>
        </div>
    </div>

    <!-- Modal de Confirmación para Eliminar Cuenta -->
    <div id="modalEliminar" class="modal">
        <div class="modal-content">
            <h3>¿Estás seguro?</h3>
            <p>Esta acción eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.</p>
            <div class="modal-buttons">
                <button class="btn-logout" onclick="cerrarModal()">Cancelar</button>
                <button class="btn-delete" onclick="eliminarCuenta()">Eliminar Cuenta</button>
            </div>
        </div>
    </div>

    <script>
        // Funciones para los botones de edición
        function editarUsuario() {
            const nuevoUsuario = prompt("Nuevo nombre de usuario:", "<%= usuario %>");
            if (nuevoUsuario && nuevoUsuario.trim() !== "") {
                // Aquí iría la llamada AJAX para actualizar el usuario
                alert("Funcionalidad en desarrollo - Próximamente");
            }
        }

        function editarEmail() {
            const nuevoEmail = prompt("Nuevo email:", "<%= email %>");
            if (nuevoEmail && nuevoEmail.trim() !== "") {
                // Aquí iría la llamada AJAX para actualizar el email
                alert("Funcionalidad en desarrollo - Próximamente");
            }
        }

        function editarPassword() {
            alert("Redirigiendo a cambio de contraseña...");
            // window.location.href = 'cambiarPassword.jsp';
        }

        function editarPerfil() {
            alert("Redirigiendo a edición de perfil...");
            window.location.href = 'editarPerfil.jsp?id_usuario=<%= idUsuario %>';
        }

        function gestionarNotificaciones() {
            alert("Gestión de notificaciones - Próximamente");
        }

        function cambiarTema() {
            alert("Cambio de tema - Próximamente");
        }

        function cambiarIdioma() {
            alert("Cambio de idioma - Próximamente");
        }

        // Funciones de gestión de cuenta
        function cerrarSesion() {
            if (confirm("¿Estás seguro de que quieres cerrar sesión?")) {
                window.location.href = 'logout.jsp';
            }
        }

        function mostrarModalEliminar() {
            document.getElementById('modalEliminar').style.display = 'block';
        }

        function cerrarModal() {
            document.getElementById('modalEliminar').style.display = 'none';
        }

        function eliminarCuenta() {
            if (confirm("¿CONFIRMAS QUE QUIERES ELIMINAR TU CUENTA PERMANENTEMENTE?")) {
                window.location.href = 'eliminarCuenta.jsp?id_usuario=<%= idUsuario %>';
            }
        }

        // Cerrar modal al hacer clic fuera
        window.onclick = function(event) {
            const modal = document.getElementById('modalEliminar');
            if (event.target === modal) {
                cerrarModal();
            }
        }
    </script>
</body>
</html>