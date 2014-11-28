<%@page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>Create Meet-up Map</title>
<link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>
	<jsp:include page="navbar.jsp"></jsp:include>
	<form class="form-horizontal" style="width: 50%" action="/addMap" method="post">
		<fieldset>
			<legend>Create Meet-up Map</legend>
			<div class="form-group">
				<label class="col-lg-2 control-label">Title</label>
				<div class="col-lg-10">
					<input type="text" name="MapTitle" class="form-control" placeholder="Title">
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-2 control-label">Users</label>
				<div class="col-lg-10">
					<input type="text" name="user" class="form-control" placeholder="User">
					<div class="checkbox">
						<label> <input type="checkbox"> Not is use yet..
						</label>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label for="textArea" name="description" class="col-lg-2 control-label">Description</label>
				<div class="col-lg-10">
					<textarea class="form-control" rows="3" id="textArea"></textarea>
				</div>
			</div>
			<div class="form-group">
				<div class="col-lg-10 col-lg-offset-2">
					<button class="btn btn-default">Cancel</button>
					<button type="submit" class="btn btn-primary">Submit</button>
				</div>
			</div>
		</fieldset>
	</form>
</body>
</html>
