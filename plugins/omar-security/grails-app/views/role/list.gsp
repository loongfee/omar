<%@ page import="org.ossim.omar.Role" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main5" />
		<title>Role List</title>
	</head>
	<body>
		<div class="nav">
			<span class="menuButton"><g:link class="home" uri="/">Home</g:link></span>
			<span class="menuButton"><g:link class="create" action="create">New Role</g:link></span>
		</div>
		<div class="body">
			<h1>Role List</h1>
			<g:if test="${flash.message}">
			<div class="message">${flash.message}</div>
			</g:if>
			<div class="list">
				<table>
				<thead>
					<tr>
						<g:sortableColumn property="id" title="Id" />
						<g:sortableColumn property="authority" title="Role Name" />
						<g:sortableColumn property="description" title="Description" />
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
				<g:each in="${authorityList}" status="i" var="authority">
					<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						<td>${authority.id}</td>
						<td>${authority.authority?.substring(5)?.toLowerCase()?.encodeAsHTML()}</td>
						<td>${authority.description?.encodeAsHTML()}</td>
						<td class="actionButtons">
							<span class="actionButton">
								<g:link action="show" id="${authority.id}">Show</g:link>
							</span>
						</td>
					</tr>
				</g:each>
				</tbody>
				</table>
			</div>

			<div class="paginateButtons">
				<g:paginate total="${Role.count()}" />
			</div>
		</div>
	</body>
</html>

