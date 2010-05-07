<%@ page import="org.ossim.omar.Repository" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main5"/>
  <title>Edit RasterDataSet</title>
</head>
<body>
<div class="nav">
  <span class="menuButton">
	<g:link class="home" controller="home">Home</g:link>
  </span>
  <span class="menuButton"><g:link class="list" action="list">RasterDataSet List</g:link></span>
  <span class="menuButton"><g:link class="create" action="create">New RasterDataSet</g:link></span>
</div>
<div class="body">
  <h1>Edit RasterDataSet</h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${rasterDataSet}">
    <div class="errors">
      <g:renderErrors bean="${rasterDataSet}" as="list"/>
    </div>
  </g:hasErrors>
  <g:form method="post">
    <input type="hidden" name="id" value="${rasterDataSet?.id}"/>
    <div class="dialog">
      <table>
        <tbody>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="fileObjects">File Objects:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: rasterDataSet, field: 'fileObjects', 'errors')}">

              <ul>
                <g:each var="f" in="${rasterDataSet?.fileObjects?}">
                  <li><g:link controller="rasterFile" action="show" id="${f.id}">${f}</g:link></li>
                </g:each>
              </ul>
              <g:link controller="rasterFile" params="[" rasterDataSet.id":rasterDataSet?.id]" action="create">Add RasterFile</g:link>

            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="rasterEntries">Raster Entries:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: rasterDataSet, field: 'rasterEntries', 'errors')}">

              <ul>
                <g:each var="r" in="${rasterDataSet?.rasterEntries?}">
                  <li><g:link controller="rasterEntry" action="show" id="${r.id}">${r}</g:link></li>
                </g:each>
              </ul>
              <g:link controller="rasterEntry" params="[" rasterDataSet.id":rasterDataSet?.id]" action="create">Add RasterEntry</g:link>

            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="repository">Repository:</label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: rasterDataSet, field: 'repository', 'errors')}">
              <g:select optionKey="id" from="${Repository.list()}" name="repository.id" value="${rasterDataSet?.repository?.id}"></g:select>
            </td>
          </tr>

        </tbody>
      </table>
    </div>
    <div class="buttons">
      <span class="button"><g:actionSubmit class="save" value="Update"/></span>
      <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete"/></span>
    </div>
  </g:form>
</div>
</body>
</html>
