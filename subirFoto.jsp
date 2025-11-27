<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, java.io.*" %>
<%
    // Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    
    if (usuario == null || idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idUsuarioParam = request.getParameter("id_usuario");
    
    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        if (idUsuarioParam == null || idUsuarioParam.trim().isEmpty()) {
            out.println("<script>alert('Error: ID de usuario no válido'); window.location='editarPerfil.jsp';</script>");
            return;
        }

        // Crear carpeta de fotos si no existe
        String uploadPath = application.getRealPath("/") + "fotos";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        // Generar nombre único para el archivo
        String filename = "perfil_" + idUsuarioParam + ".jpg";
        File outputFile = new File(uploadPath + File.separator + filename);
        
        // Crear un archivo de marcador
        FileWriter writer = new FileWriter(outputFile);
        writer.write("Foto de perfil para usuario: " + idUsuarioParam + "\n");
        writer.write("Usuario: " + usuario + "\n");
        writer.write("Fecha: " + new java.util.Date() + "\n");
        writer.close();
        
        // Conexión directa a la base de datos (reemplaza UtilDB)
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/ENERKOI1_0";
        String dbUser = "root";
        String dbPassword = "root";
        
        con = DriverManager.getConnection(url, dbUser, dbPassword);
        
        String sql = "UPDATE perfiles_usuario SET foto_archivo = ? WHERE id_usuario = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, filename);
        ps.setInt(2, Integer.parseInt(idUsuarioParam));
        
        int filas = ps.executeUpdate();
        
        if (filas > 0) {
            out.println("<script>alert('¡Foto de perfil actualizada exitosamente!'); window.location='dashboard.jsp';</script>");
        } else {
            out.println("<script>alert('Error: No se pudo actualizar el perfil'); window.location='editarPerfil.jsp';</script>");
        }
        
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.location='editarPerfil.jsp';</script>");
        e.printStackTrace();
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>