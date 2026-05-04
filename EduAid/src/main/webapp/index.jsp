<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Root index page: redirect to login --%>
<% response.sendRedirect(request.getContextPath() + "/auth?action=login"); %>
