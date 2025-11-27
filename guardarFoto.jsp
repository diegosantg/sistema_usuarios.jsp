<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, java.io.*, librerias.base.UtilDB" %>
<%
    String idUsuario = request.getParameter("id_usuario");
    
    if (idUsuario == null) {
        out.println("Error: ID de usuario requerido");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        // Crear carpeta de fotos
        String uploadPath = application.getRealPath("/") + "fotos";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        // Generar nombre de archivo
        String filename = "perfil_" + idUsuario + ".jpg";
        
        // En una implementación real, aquí procesarías el archivo multipart
        // Por ahora creamos un archivo de marcador
        
        File markerFile = new File(uploadPath + File.separator + filename);
        FileWriter writer = new FileWriter(markerFile);
        writer.write("Foto de perfil para usuario " + idUsuario);
        writer.close();
        
        // Actualizar base de datos
        con = UtilDB.getConnection();
        String sql = "UPDATE perfiles_usuario SET foto_archivo = ? WHERE id_usuario = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, filename);
        ps.setInt(2, Integer.parseInt(idUsuario));
        
        int filas = ps.executeUpdate();
        
        if (filas > 0) {
            out.println("<script>alert('Foto configurada exitosamente'); window.location='dashboard.jsp';</script>");
        } else {
            out.println("<script>alert('Error al guardar en base de datos'); history.back();</script>");
        }
        
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>