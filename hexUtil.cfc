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
	Name         : hexUtil.cfc
	Author(s)    : Daniel Budde
	Created      : Nov 30, 2016
	Requirements : ColdFusion 11+
*/
component accessors="true" output="false" hint="Hexadecimal to decimal utilities conversion component." 
{
	/**********************************/
	/** Properties                   **/
	/**********************************/




	/**********************************/
	/** Public Methods               **/
	/**********************************/
	public string function decimalToHex(required numeric number) hint="Converts a decimal based number to it's hexadecimal equivalent."
	{
		local.hexValue = "";

		if (arguments.number <= 15)
		{
			if (arguments.number <= 9)
			{
				local.hexValue &= arguments.number;
			}
			else
			{
				local.hexValue &= chr(55 + arguments.number);
			}
		}
		else
		{
			local.number = arguments.number;
			local.counter = 0;

			while (local.number > 0 && local.counter < 100)
			{
				local.quotient = castInt(listFirst(local.number / 16, "."));
				local.remainder = local.number - (local.quotient * 16);

				local.hexValue = decimalToHex(local.remainder) & local.hexValue;

				local.number = local.quotient;

				local.counter++;
			}
		}


		return local.hexValue;
	}


	public numeric function hexCharToDecimal(required string char) hint="Converts a hex based character to it's decimal based value (0 - 15)."
	{
		local.value = lcase(arguments.char);

		if (!isNumeric(local.value))
		{
			if (local.value == "a")
			{
				local.value = 10;
			}
			else if (local.value == "b")
			{
				local.value = 11;
			}
			else if (local.value == "c")
			{
				local.value = 12;
			}
			else if (local.value == "d")
			{
				local.value = 13;
			}
			else if (local.value == "e")
			{
				local.value = 14;
			}
			else if (local.value == "f")
			{
				local.value = 15;
			}
			else
			{
				local.value = 0;
			}
		}
		else if (local.value > 9)
		{
			local.value = 0;
		}


		return castInt(local.value);
	}


	public numeric function hexToDecimal(required string hexValue) hint="Converts a hex based value to an decimal based value."
	{
		local.hexValue = lcase(arguments.hexValue);
		local.intValue = 0;

		for (local.i = 1; local.i <= len(local.hexValue); local.i++)
		{
			local.position = len(local.hexValue) - local.i + 1;
			local.character = mid(local.hexValue, local.position, 1);

			local.power = local.i - 1;

			local.intValue += (hexCharToDecimal(local.character) * (16^local.power));
		}

		return castInt(local.intValue);
	}


	public boolean function isHex(required string hexValue) hint="Determines if a string is a Hex value consisting of characters 0-9 or A-F."
	{
		local.isHex = true;
		local.value = lcase(reReplace(arguments.hexValue, "\d", "", "all"));
		local.value = reReplace(local.value, "[a-f]", "", "all");

		if (len(local.value))
		{
			local.isHex = false;
		}

		return local.isHex;
	}




	/**********************************/
	/** Private Methods              **/
	/**********************************/
	private numeric function castInt(required any value) hint="Casts a value to an integer."
	{
		return javacast("int", arguments.value);
	}


}