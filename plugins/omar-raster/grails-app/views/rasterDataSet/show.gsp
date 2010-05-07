<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main5"/>
  <title>Show RasterDataSet</title>
</head>
<body>
<div class="nav">
  <span class="menuButton">
	<g:link class="home" controller="home">Home</g:link>
  </span>
  <span class="menuButton"><g:link class="list" action="list">RasterDataSet List</g:link></span>
  <g:ifAllGranted role="ROLE_ADMIN">
    <span class="menuButton"><g:link class="create" action="create">New RasterDataSet</g:link></span>
  </g:ifAllGranted>
</div>
<div class="body">
  <h1>Show RasterDataSet</h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="dialog">
    <table>
      <tbody>

        <tr class="prop">
          <td valign="top" class="name">Id:</td>

          <td valign="top" class="value">${rasterDataSet.id}</td>

        </tr>

        <tr class="prop">
          <td valign="top" class="name">File Objects:</td>

          <td valign="top" style="text-align:left;" class="value">
            <g:if test="${rasterDataSet.fileObjects}">
              <g:link controller="rasterFile" action="list" params="${[rasterDataSetId: rasterDataSet.id]}">Show Raster Files</g:link>
            </g:if>
          </td>

        </tr>

        <tr class="prop">
          <td valign="top" class="name">Raster Entries:</td>

          <td valign="top" style="text-align:left;" class="value">
            <g:if test="${rasterDataSet.rasterEntries}">
              <g:link controller="rasterEntry" action="list" params="${[rasterDataSetId: rasterDataSet.id]}">Show Raster Entries</g:link>
            </g:if>
          </td>

        </tr>

        <tr class="prop">
          <td valign="top" class="name">Repository:</td>

          <td valign="top" class="value"><g:link controller="repository" action="show" id="${rasterDataSet?.repository?.id}">${rasterDataSet?.repository}</g:link></td>

        </tr>

      </tbody>
    </table>
  </div>
  <div class="buttons">
    <g:form>
      <input type="hidden" name="id" value="${rasterDataSet?.id}"/>
      <g:ifAllGranted role="ROLE_ADMIN">
        <span class="button"><g:actionSubmit class="edit" value="Edit"/></span>
        <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete"/></span>
      </g:ifAllGranted>
    </g:form>
  </div>
</div>
</body>
</html>
