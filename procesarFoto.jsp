<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%
    // Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    
    if (usuario == null || idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        // Verificar si es multipart
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        
        if (!isMultipart) {
            out.println("<script>alert('Error: No se recibió archivo'); window.location='editarPerfil.jsp';</script>");
            return;
        }

        // Configurar FileUpload
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(4096);
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(5 * 1024 * 1024);

        // Procesar items - Java 1.4 compatible
        List items = upload.parseRequest(request);
        Iterator iter = items.iterator();
        FileItem fotoItem = null;
        String idUsuarioParam = null;
        
        while (iter.hasNext()) {
            FileItem item = (FileItem) iter.next();
            
            if (item.isFormField()) {
                // Campo normal
                if ("id_usuario".equals(item.getFieldName())) {
                    idUsuarioParam = item.getString("UTF-8");
                }
            } else if ("fotoPerfil".equals(item.getFieldName()) && item.getSize() > 0) {
                fotoItem = item;
            }
        }
        
        if (fotoItem != null && idUsuarioParam != null) {
            // Crear carpeta de fotos si no existe
            String uploadPath = application.getRealPath("/") + "fotos";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Generar nombre único para el archivo
            String fileExtension = "";
            String contentType = fotoItem.getContentType();
            if (contentType != null) {
                if (contentType.equals("image/jpeg")) fileExtension = ".jpg";
                else if (contentType.equals("image/png")) fileExtension = ".png";
                else if (contentType.equals("image/gif")) fileExtension = ".gif";
                else fileExtension = ".jpg"; // Por defecto
            }
            
            String fileName = "perfil_" + idUsuarioParam + fileExtension;
            File storeFile = new File(uploadPath + File.separator + fileName);
            fotoItem.write(storeFile);
            
            // CONFIGURA TU CONEXIÓN A LA BASE DE DATOS AQUÍ:
            // ==============================================
             String url = "jdbc:mysql://localhost:3306/ENERKOI1_0";  // ← Tu base de datos
String user = "root";                                // ← Tu usuario MySQL  
String password = "root";                             // CAMBIA
            // ==============================================
            
            con = DriverManager.getConnection(url, user, password);
            
            // PRIMERO: Modifica la tabla para guardar el nombre del archivo
            // Ejecuta esto en tu base de datos:
            // ALTER TABLE perfiles_usuario ADD COLUMN foto_archivo VARCHAR(255);
            
            String sql = "UPDATE perfiles_usuario SET foto_archivo = ? WHERE id_usuario = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, fileName);
            ps.setInt(2, Integer.parseInt(idUsuarioParam));
            
            int filas = ps.executeUpdate();
            
            if (filas > 0) {
                out.println("<script>alert('Foto de perfil actualizada exitosamente'); window.location='dashboard.jsp';</script>");
            } else {
                out.println("<script>alert('Error: No se pudo actualizar el perfil'); window.location='editarPerfil.jsp';</script>");
            }
        } else {
            out.println("<script>alert('Error: No se seleccionó ninguna foto válida'); window.location='editarPerfil.jsp';</script>");
        }
        
    } catch (FileUploadException e) {
        out.println("<script>alert('Error: El archivo es demasiado grande (máximo 5MB)'); window.location='editarPerfil.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.location='editarPerfil.jsp';</script>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>