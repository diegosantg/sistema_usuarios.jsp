<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ENERKOI - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="js/dashboard.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    String nombreUsuario = (String) session.getAttribute("nombre_usuario");
    
    if (usuario == null || idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

    <!-- Contenido principal responsive -->
    <div class="dashboard-container">
        
        <!-- Barra de búsqueda -->
        <div class="search-section">
            <div class="search-bar">
                <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                </svg>
                <input type="text" placeholder="Buscar rutinas..." class="search-input">
                <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 14c1.66 0 2.99-1.34 2.99-3L15 5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.3-3c0 3-2.54 5.1-5.3 5.1S6.7 14 6.7 11H5c0 3.41 2.72 6.23 6 6.72V21h2v-3.28c3.28-.48 6-3.3 6-6.72h-1.7z"/>
                </svg>
            </div>
        </div>

        <!-- Tarjeta de saludo -->
        <div class="greeting-card">
          <div class="avatar" onclick="window.location.href='editarPerfil.jsp'" style="cursor: pointer;">
    <img id="userAvatar" 
         src="verFoto.jsp?id_usuario=<%= idUsuario %>" 
         onerror="this.style.display='none'; document.getElementById('avatarFallback').style.display='flex';"
         alt="Foto de perfil" 
         style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
    <div id="avatarFallback" class="avatar-fallback" style="display: none;">
        <div class="avatar-initial"><%= usuario != null ? usuario.substring(0, 1).toUpperCase() : "U" %></div>
    </div>
</div>
            <div class="greeting-text">
                <h1>Hola <%= usuario %>!</h1>
               
            </div>
        </div>

        <!-- Botones principales -->
       

        <!-- Rutinas de a modo de resumen lol -->
     

        <!-- barra de iconos para movrse en la app  -->
        <nav class="bottom-nav">
            <!------ Icono rutinas -->
            <a class="nav-icon" href="rutinas.jsp">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                <path d="M3 13h2v-2H3v2zm0 4h2v-2H3v2zm0 4h2v-2H3v2zm12 0h2v-2h-2v2zm-4 0h2v-2h-2v2zm-4 0h2v-2H7v2zm8-4h2v-2h-2v2zm-4 0h2v-2h-2v2zm-4 0h2v-2H7v2zm8-8h2V7h-2v2zm-4 0h2V7h-2v2zm-4 0h2V7H7v2zm12 4h2v-2h-2v2z"/>
            </svg>
            </a>
            <!------ Icono ejercicios -->
            <a class="nav-icon" href="ejercicios.jsp">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                <path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/>
            </svg>
            </a>
            <!------ Icono home -->
            <a class="nav-icon active" href="dashboard.jsp">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
            </svg>
            </a>
            <!------ Icono perfil -->
            <a class="nav-icon" href="perfil.jsp">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
            </svg>
            </a>
            <!------ Icono ajuses -->
            <a class="nav-icon" href="ajustes.jsp">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
            </svg>
            </a>
        </nav>

    </div>

    <script>
        // Efectos de interacción
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto hover en botones
            const buttons = document.querySelectorAll('.btn-primary, .btn-secondary');
            buttons.forEach(btn => {
                btn.addEventListener('mouseover', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = '0 12px 30px rgba(255, 59, 59, 0.15)';
                });
                
                btn.addEventListener('mouseout', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 10px 30px rgba(255, 59, 59, 0.08)';
                });
            });

            // Efecto en tarjetas de rutina
            const routineCards = document.querySelectorAll('.routine-card');
            routineCards.forEach(card => {
                card.addEventListener('click', function() {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = 'scale(1)';
                    }, 150);
                });
            });

            // Navegación inferior
            const navIcons = document.querySelectorAll('.nav-icon');
            navIcons.forEach(icon => {
                icon.addEventListener('click', function() {
                    navIcons.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        });
        function openPhotoUpload() {
    // Esto podría abrir un modal o redirigir a una página de edición de perfil
    window.location.href = 'editarPerfil.jsp';
}
    </script>
    
</body>
</html>