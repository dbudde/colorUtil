/**
	MIT License

	Copyright (c) 2016 Daniel Budde

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

/**
	Name         : colorUtil.cfc
	Author(s)    : Daniel Budde
	Created      : Nov 30, 2016
	Requirements : ColdFusion 11+
*/
component extends="hexUtil" accessors="true" output="false" hint="Color utilities component." 
{
	/**********************************/
	/** Properties                   **/
	/**********************************/




	/**********************************/
	/** Public Methods               **/
	/**********************************/

	/**
	* @alpha	Value representing the alpha level (opacity) of the color (0 - 255).
	* @red		Value representing the red level of the color (0 - 255).
	* @green	Value representing the green level of the color (0 - 255).
	* @blue		Value representing the blue level of the color (0 - 255).
	*/
	public any function argbToInteger(required numeric alpha, required numeric red, required numeric green, required numeric blue)
		hint="Takes ARGB value and converts it to a single integer RGBA."
	{
		return rgbaToInteger(arguments.alpha, arguments.red, arguments.green, arguments.blue);
	}


	/**
	* @hexColor		Hex value representing a color.
	* @alpha		Value representing the alpha level (opacity) of the color (0 - 255).
	* @red			Value representing the red level of the color (0 - 255).
	* @green		Value representing the green level of the color (0 - 255).
	* @blue			Value representing the blue level of the color (0 - 255).
	*/
	public any function getColor(string hexColor, numeric alpha = 255, numeric red, numeric green, numeric blue)
		hint="Takes a hex color value or RGB and returns a Java color object. (ex. getColor('ff0000') or getColor(255, 0, 0) )"
	{
		// Handle if a RGB or RGBA color was passed in the first 3 or 4 positions.
		if (
			arguments.keyExists("hexColor") && isNumeric(arguments.hexColor) && isValidColorValue(arguments.hexColor) && 
			arguments.keyExists("alpha") && isValidColorValue(arguments.alpha) && 
			arguments.keyExists("red") && isValidColorValue(arguments.red)
		)
		{
			local.args =
			{
				"red": arguments.hexColor,
				"green": arguments.alpha,
				"blue": arguments.red
			};

			// Alpha was included
			if (arguments.keyExists("green") && isValidColorValue(arguments.green))
			{
				local.args["alpha"] = arguments.green;
			}

			arguments.clear();
			arguments = local.args;
			local.delete("args");
		}


		if (!arguments.keyExists("alpha") || !isValidColorValue(arguments.alpha))
		{
			arguments.alpha = 255;
		}


		// Handle hex color value.
		if (arguments.keyExists("hexColor") && len(arguments.hexColor) && isHexColor(arguments.hexColor))
		{
			return hexToColor(arguments.hexColor, arguments.alpha);
		}

		// Handle RGBA color value.
		else if (
			arguments.keyExists("red") &&
			arguments.keyExists("green") &&
			arguments.keyExists("blue") &&
			isValidColorValue(arguments.red) && 
			isValidColorValue(arguments.green) && 
			isValidColorValue(arguments.blue) && 
			isValidColorValue(arguments.alpha)
		)
		{
			return createColor(argumentCollection = arguments);
		}
	}


	public numeric function hexToColor(required string hexColor, numeric alpha = 255) 
		hint="Takes a hex based web color and returns a java Color object. Returns a 'black' color object if an invalid hex color is given."
	{
		if (!isHexColor(arguments.hexColor))
		{
			arguments.hexColor = "000000";
		}

		if (!isValidColorValue(arguments.alpha))
		{
			arguments.alpha = 255;
		}


		local.rgba = hexToRGB(arguments.hexColor);
		local.rgba["alpha"] = arguments.alpha;

		return createColor(argumentCollection = local.rgba);
	}


	public struct function hexToRGB(required string hexColor) hint="Converts a hex based color to an RGB representation."
	{
		local.rgb = {"red" = 0, "green" = 0, "blue" = 0};

		if (isHexColor(arguments.hexColor))
		{
			local.rgb.red = castInt(hexToDecimal(mid(arguments.hexColor, 1, 2)));
			local.rgb.green = castInt(hexToDecimal(mid(arguments.hexColor, 3, 2)));
			local.rgb.blue = castInt(hexToDecimal(mid(arguments.hexColor, 5, 2)));
		}

		return local.rgb;
	}


	public boolean function isHexColor(required string hexValue) hint="Determines if a string is a web Hex value for a color."
	{
		return len(arguments.hexValue) == 6 and isHex(arguments.hexValue);
	}


	public numeric function rgbaToInteger(required numeric red, required numeric green, required numeric blue, required numeric alpha) 
		hint="Takes a RGBA struct and converts it to a single integer RGBA. Assumes that all color values are valid (between 0 - 255)."
	{
		arguments.red = bitAnd(castInt(arguments.red), castInt(255));
		arguments.green = bitAnd(castInt(arguments.green), castInt(255));
		arguments.blue = bitAnd(castInt(arguments.blue), castInt(255));
		arguments.alpha = bitAnd(castInt(arguments.alpha), castInt(255));

		local.rgbaInt = bitSHLN(arguments.red, 24);
		local.rgbaInt += bitSHLN(arguments.green, 16);
		local.rgbaInt += bitSHLN(arguments.blue, 8);
		local.rgbaInt += arguments.alpha;

		return local.rgbaInt;
	}


	public any function rgbToColor(required numeric red, required numeric green, required numeric blue, required numeric alpha) 
		hint="Converts RGB to a Java color object."
	{
		if (!isValidColorValue(arguments.red))
		{
			arguments.red = 0;
		}

		if (!isValidColorValue(arguments.green))
		{
			arguments.green = 0;
		}

		if (!isValidColorValue(arguments.blue))
		{
			arguments.blue = 0;
		}

		if (!isValidColorValue(arguments.alpha))
		{
			arguments.alpha = 255;
		}

		return createColor(argumentCollection = arguments);
	}


	public any function rgbToHex(required numeric red, required numeric green, required numeric blue) hint="Converts RGB values to a hex color value."
	{
		local.red = decimalToHex(arguments.red);
		local.green = decimalToHex(arguments.green);
		local.blue = decimalToHex(arguments.blue);

		if (len(local.red) == 1)
		{
			local.red = "0" & local.red;
		}

		if (len(local.green) == 1)
		{
			local.green = "0" & local.green;
		}

		if (len(local.blue) == 1)
		{
			local.blue = "0" & local.blue;
		}

		return local.red & local.green & local.blue; 
	}




	/**********************************/
	/** Private Methods              **/
	/**********************************/
	private any function createColor(required numeric red, required numeric green, required numeric blue, required numeric alpha) 
		hint="Creates a Java color object from RGBA values."
	{
		return createObject("java", "java.awt.Color").init(castInt(arguments.red), castInt(arguments.green), castInt(arguments.blue), castInt(arguments.alpha));
	}


	private boolean function isValidColorValue(required numeric value) hint="Determines if a value is between 0 and 255"
	{
		if (arguments.value >= 0 && arguments.value <= 255)
		{
			return true;
		}

		return false;
	}


}