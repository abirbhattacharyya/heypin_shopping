// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function popup(pageURL, title, popupWidth, popupHeight)
    {
        var left = (screen.width / 2) - (popupWidth / 2);
        var top = (screen.height / 2) - (popupHeight / 2);
         targetPop = window.open(pageURL, title, "toolbar=no, location=no, directories=no,status=no, menubar=no, scrollbars=YES, resizable=YES, copyhistory=no, width=" + popupWidth + ',height=' + popupHeight + ', top=' + top + ', left=' + left);
    if (window.focus) {targetPop.focus()}
    return false;
    }

function keyAllowed(e, validchars)
{
     var key='', keychar='';
     key = getKeyCode(e);
     if (key == null) return true;
     keychar = String.fromCharCode(key);
     keychar = keychar.toLowerCase();
     validchars = validchars.toLowerCase();
     if (validchars.indexOf(keychar) != -1)
        return true;
     if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 )
        return true;
     return false;
}
function removeChars(str)
{
    var val = str.replace(/[^\d]/g, "");
    if(val.charAt(0) == "0"){
        val = val.substring(1,val.length)
    }
    return val
}

function getKeyCode(e)
{
     if (window.event)
        return window.event.keyCode;
     else if (e)
        return e.which;
     else
        return null;
}
function charCount(id,Div,num)
{
    var str=document.getElementById(id).value;
    if((num-str.length)<0)
    {
        document.getElementById(id).value=str.substring(0,num);str=document.getElementById(id).value;
    }
    var left_char=num-str.length
    document.getElementById(Div).innerHTML=left_char;
}
function isNumber(field)
{
    var re = /^[0-9-'.'-',']*$/;
    if (!re.test(field.value))
    {
    field.value = field.value.replace(/[^0-9-'.'-',']/g,"");
    }
    field.value = Comma(field.value);
}
function Comma(number)
{
    //var number = document.getElementById(id).value;
    number = removeCommas(number);
    var tnumber = number;
    var roundedNumber = roundNumber(number,0);
    number = roundedNumber;
    if (roundedNumber > tnumber)
    {
        var rnumber = roundedNumber - tnumber
    }
    else
    {
        var rnumber = tnumber - roundedNumber
    }
    number = '' + number;
    if (number.length > 3)
    {
        var mod = number.length % 3;
        var output = (mod > 0 ? (number.substring(0,mod)) : '');
        for (i=0 ; i < Math.floor(number.length / 3); i++)
        {
            if ((mod == 0) && (i == 0))
                output += number.substring(mod+ 3 * i, mod + 3 * i + 3);
            else
                output+= ',' + number.substring(mod + 3 * i, mod + 3 * i + 3);
        }

        if((rnumber > 0) && (tnumber< 999))
        {
            output = output + "." + rnumber;
        }
        return (output);
    }
    else
    {
        if (number != "")
        {
            var output = parseFloat(removeCommas(number));
            if(output == 0)
                output = ""

            return output;
        }
        else
        {
            return ""
        }
    }
}
function roundNumber(num, dec)
{
    var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
    return result;
}

function removeCommas(aNum)
{
    aNum=aNum.replace(/,/g,""); //remove any commas
    aNum=aNum.replace(/\s/g,""); //remove any spaces
    return aNum;
}


function calc_price(price_id,qty_id,qty,price){
    var total_price = qty * price;
    $(price_id).innerHTML = "$" + Comma(total_price + '');

}

function pad2(number){  
  var num = (number > 9) ? number : "0" + number;
  return num
}