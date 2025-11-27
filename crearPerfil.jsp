<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<%@ page import="java.sql.*, librerias.base.*, librerias.comun.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>COMPLETA TU PERFIL - ENERKOI</title>
    <link href="js/perfil32.css" rel="stylesheet" type="text/css" />
    <link href="img/logo_enerkoi2.0.png" rel="shortcut icon" type="image/png" />
</head>

<body bgproperties="fixed" topmargin="0" leftmargin="0">

<%
    // Procesar el formulario de perfil
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Configurar encoding UTF-8 para los parámetros
        request.setCharacterEncoding("UTF-8");
        
        String idUsuario = request.getParameter("id_usuario");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String genero = request.getParameter("genero");
        String altura = request.getParameter("altura");
        String peso = request.getParameter("peso");
        String nivelExperiencia = request.getParameter("nivelExperiencia");
        String objetivo = request.getParameter("objetivo");
        String lesiones = request.getParameter("lesiones");

        // Validar que id_usuario no sea nulo
        if (idUsuario == null || idUsuario.trim().isEmpty()) {
            out.println("<script>alert('Error: ID de usuario no válido'); window.location='registro.jsp';</script>");
        } else {
            Connection con = null;
            PreparedStatement ps = null;

            try {
                con = UtilDB.getConnection();
                String sql = "INSERT INTO perfiles_usuario (id_usuario, fecha_nacimiento, genero, altura, peso, nivel_experiencia, objetivo, lesiones) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);

                ps.setInt(1, Integer.parseInt(idUsuario));
                ps.setString(2, fechaNacimiento);
                ps.setString(3, genero);
                ps.setDouble(4, Double.parseDouble(altura));
                ps.setDouble(5, Double.parseDouble(peso));
                ps.setString(6, nivelExperiencia);
                ps.setString(7, objetivo);
                ps.setString(8, lesiones);

                int filas = ps.executeUpdate();

                if (filas > 0) {
                    out.println("<script>alert('Perfil completado exitosamente'); window.location='dashboard.jsp';</script>");
                } else {
                    out.println("<script>alert('Error al guardar el perfil'); history.back();</script>");
                }

            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
            } finally {
                if (ps != null) try { ps.close(); } catch (Exception ex) {}
                if (con != null) try { con.close(); } catch (Exception ex) {}
            }
        }
    }

    String idUsuario = request.getParameter("id_usuario");
    // Validar que id_usuario no sea nulo al cargar la página
    if (idUsuario == null || idUsuario.trim().isEmpty()) {
        out.println("<script>alert('ID de usuario no válido'); window.location='registro.jsp';</script>");
        return;
    }
%>

<div class="login-container profile-container">
    <a href="inicio.jsp"><img class="logo" src="img/logo_enerkoi2.0.png" alt="logo"></a>
    <h2>Completa Tu Perfil</h2>
    <p class="subtitle">Ayúdanos a personalizar tu experiencia de entrenamiento</p>

    <form method="post" accept-charset="UTF-8">
        <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
        
        <div class="form-group">
            <label for="fechaNacimiento">Fecha de Nacimiento</label>
            <input type="date" id="fechaNacimiento" name="fechaNacimiento" required>
        </div>

        <div class="form-group">
            <label for="genero">Género</label>
            <select id="genero" name="genero" required>
                <option value="">Selecciona tu género</option>
                <option value="masculino">Masculino</option>
                <option value="femenino">Femenino</option>
                <option value="otro">Otro</option>
                <option value="prefiero_no_decir">Prefiero no decir</option>
            </select>
        </div>

        <div class="form-row">
            <div class="form-group half">
                <label for="altura">Altura (cm)</label>
                <input type="number" id="altura" name="altura" min="100" max="250" step="0.1" placeholder="Ej: 175" required>
            </div>

            <div class="form-group half">
                <label for="peso">Peso (kg)</label>
                <input type="number" id="peso" name="peso" min="30" max="200" step="0.1" placeholder="Ej: 70.5" required>
            </div>
        </div>

        <div class="form-group">
            <label for="nivelExperiencia">Nivel de Experiencia</label>
            <select id="nivelExperiencia" name="nivelExperiencia" required>
                <option value="">Selecciona tu nivel</option>
                <option value="principiante">Principiante</option>
                <option value="intermedio">Intermedio</option>
                <option value="avanzado">Avanzado</option>
            </select>
        </div>

        <div class="form-group">
            <label class="goal-label">Tu Objetivo Principal</label>
            <div class="goals-container">
                <div class="goal-option" onclick="selectGoal(this, 'perdida_peso')">
                    <strong>Pérdida de Peso</strong>
                    <span>Quemar grasa</span>
                </div>
                <div class="goal-option" onclick="selectGoal(this, 'ganancia_muscular')">
                    <strong>Ganancia Muscular</strong>
                    <span>Aumentar masa</span>
                </div>
                <div class="goal-option" onclick="selectGoal(this, 'mantenimiento')">
                    <strong>Mantenimiento</strong>
                    <span>Mantenerse en forma</span>
                </div>
                <div class="goal-option" onclick="selectGoal(this, 'fuerza')">
                    <strong>Aumentar Fuerza</strong>
                    <span>Mayor potencia</span>
                </div>
            </div>
            <input type="hidden" id="objetivo" name="objetivo" required>
        </div>

        <div class="form-group">
            <label for="lesiones">Lesiones o Condiciones Médicas</label>
            <input type="text" id="lesiones" name="lesiones" placeholder="Ej: Lesión de rodilla, asma, etc. (opcional)">
        </div>

        <button type="submit" class="submit-btn">Completar Perfil</button>
    </form>
</div>

<script>
    function selectGoal(element, goal) {
        // Remover selección anterior
        document.querySelectorAll('.goal-option').forEach(opt => {
            opt.classList.remove('selected');
        });
        
        // Seleccionar nuevo
        element.classList.add('selected');
        document.getElementById('objetivo').value = goal;
    }

    // Validación del formulario
    document.querySelector('form').addEventListener('submit', function(e) {
        const objetivo = document.getElementById('objetivo').value;
        if (!objetivo) {
            e.preventDefault();
            alert('Por favor selecciona tu objetivo principal');
            return false;
        }
        
        // Validar fecha de nacimiento (mínimo 12 años, máximo 100 años)
        const fechaNacimiento = new Date(document.getElementById('fechaNacimiento').value);
        const hoy = new Date();
        const edadMinima = new Date();
        edadMinima.setFullYear(hoy.getFullYear() - 12);
        const edadMaxima = new Date();
        edadMaxima.setFullYear(hoy.getFullYear() - 100);
        
        if (fechaNacimiento > edadMinima) {
            e.preventDefault();
            alert('Debes tener al menos 12 años para registrarte');
            return false;
        }
        
        if (fechaNacimiento < edadMaxima) {
            e.preventDefault();
            alert('Por favor ingresa una fecha de nacimiento válida');
            return false;
        }
    });

    // Establecer fecha máxima (12 años atrás) y mínima (100 años atrás)
    window.onload = function() {
        const fechaInput = document.getElementById('fechaNacimiento');
        const hoy = new Date();
        const maxDate = new Date();
        maxDate.setFullYear(hoy.getFullYear() - 12);
        const minDate = new Date();
        minDate.setFullYear(hoy.getFullYear() - 100);
        
        fechaInput.max = maxDate.toISOString().split('T')[0];
        fechaInput.min = minDate.toISOString().split('T')[0];
    };
</script>
</body>
</html>