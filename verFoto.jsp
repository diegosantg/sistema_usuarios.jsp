<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>
<%
    String idUsuario = request.getParameter("id_usuario");
    
    if (idUsuario == null) {
        response.sendError(404, "Usuario no especificado");
        return;
    }

    // Ruta donde se guardan las fotos
    String fotoPath = application.getRealPath("/") + "fotos";
    String nombreArchivo = "perfil_" + idUsuario + ".jpg";
    File archivoFoto = new File(fotoPath, nombreArchivo);
    
    // Verificar si el archivo existe
    if (archivoFoto.exists()) {
        // Redirigir directamente al archivo
        response.sendRedirect("fotos/" + nombreArchivo);
    } else {
        // Mostrar avatar por defecto como SVG
        response.setContentType("image/svg+xml");
        String inicial = "U"; // Inicial por defecto
%>
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
    <circle cx="50" cy="50" r="50" fill="#FF3B3B"/>
    <text x="50" y="60" text-anchor="middle" fill="white" 
          font-family="Arial, sans-serif" font-size="40" font-weight="bold">
        <%= inicial %>
    </text>
</svg>
<%
    }
%>