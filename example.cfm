<cfsetting enablecfoutputonly="true" />
<cfscript>
	colorUtil = new colorUtil();

	rgbToHex = {"rgb": {"red": 255, "green": 122, "blue": 204}, "hex": ""};
	rgbToHex.hex = colorUtil.rgbToHex(argumentCollection = rgbToHex.rgb);

	hexToRGB = {"rgb": {}, "hex": "5ed6ff"};
	hexToRGB.rgb = colorUtil.hexToRGB(hexToRGB.hex);

	rgbColor = colorUtil.getColor(255, 122, 204);
	hexColor = colorUtil.getColor("ff0000");
</cfscript>
<cfsetting enablecfoutputonly="false" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Hexadecimal Example</title>
	<style>
		div.col {
			float: left;
			margin-left: 1%;
			padding: 10px;
		}	
	</style>
</head>
<body>
	<div class="col" style="width: 20%;">
		<h3>RGB to Hex</h3>
		<cfdump var="#rgbToHex#" />
	</div>
	<div class="col" style="width: 20%;">
		<h3>Hex to RGB</h3>
		<cfdump var="#hexToRGB#" />
	</div>
	<div class="col" style="width: 50%;">
		<h3>RGB Color</h3>
		<cfdump var="#rgbColor#" expand="no" />

		<h3>Hex Color</h3>
		<cfdump var="#hexColor#" expand="no" />
	</div>
</body>
</html>