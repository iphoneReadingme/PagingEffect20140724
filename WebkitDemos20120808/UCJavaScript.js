// add 2012-01-12

function UCWEBAppHandleIFrameElement(x, y, e, needAddScroll)
{
	if (e.tagName == 'IFRAME' || e.tagName == 'iframe')
	{
		var left = e.getBoundingClientRect().left;
		var top = e.getBoundingClientRect().top;
		if (needAddScroll) {
			left += window.pageXOffset;
			top += window.pageYOffset;
		}
		
		e = e.contentDocument.elementFromPoint(x-left,y-top);
	}
	
	return e;
}

function UCWEBAppGetHTMLElementsAtPoint(x,y,needAddScroll)
{
	var tags = "■";
	var e = document.elementFromPoint(x,y);
	while (e)
	{
		if (e.tagName)
		{
			e = UCWEBAppHandleIFrameElement(x, y, e, needAddScroll);
			if(e.tagName == 'A' || e.tagName =='a')
			{
				tags +=  e.tagName + '■';
				tags +=  e.href + '■';
				tags +=  e.text + '■';
				//break;
			}
			else if(e.tagName == 'IMG' || e.tagName == 'img')
			{
				tags +=  e.tagName + '■';
				tags +=  e.src + '■';
				//break;
			}
			else if((e.tagName == 'AREA' || e.tagName == 'area') && e.href != null)
			{
				tags +=  e.tagName + '■';
				tags +=  e.href + '■';
				//break;
			}
		}
		e = e.parentNode;
	}
	return tags;
}

var UCWEBApp_s_baseTarget;

function UCWEBAppGetBaseTarget()
{
	if(!UCWEBApp_s_baseTarget)
	{
		var bases = document.getElementsByTagName('base');
		if(bases.length > 0)
		{
			UCWEBApp_s_baseTarget = bases[0].target;
		}
	}
	
	return UCWEBApp_s_baseTarget;
}

function UCWEBAppGetLinkAtPoint(x,y,needAddScroll)
{
	var tags = "■";
	var baseTarget = UCWEBAppGetBaseTarget();
	
	var e = document.elementFromPoint(x,y);
	while (e)
	{
		if (e.tagName)
		{
			e = UCWEBAppHandleIFrameElement(x, y, e, needAddScroll);
			
			if(e.tagName == 'A' || e.tagName =='a')
			{
				tags +=  e.tagName + '■';
				tags +=  e.href + '■';
				tags +=  e.text + '■';
				
				var target = e.target ? e.target : baseTarget;
				tags += target;
			}
		}
		
		e = e.parentNode;
	}
	return tags;
}


function UCWEBAppGetLinkSRCAtPoint(x,y)
{
	var tags = "";
	var e = document.elementFromPoint(x,y);
	while (e)
	{
		if (e.src)
		{
			//tags += e.src;
			//tags +=  e.tagName + '■';
			//tags +=  e.src + '■';
			break;
		}
		e = e.parentNode;
	}
	return tags;
}

function UCWEBAppGetLinkHREFAtPoint(x,y)
{
	var tags = "";
	var e = document.elementFromPoint(x,y);
	while (e)
	{
		if (e.href)
		{
			tags += e.href;
			//tags +=  e.tagName + '■';
			//tags +=  e.href + '■';
			break;
		}
		e = e.parentNode;
	}
	return tags;
}



function TestUCWEBAppGetLinkHREFAtPoint(x,y)
{
	var tags = "";
	var tagNameStr = "";
	var e = document.elementFromPoint(x,y);
	while (e)
	{
		//if (e.href)
		{
			tagNameStr = e.tagName;
			tagNameStr = tagNameStr.toLowerCase();
			tags +=  tagNameStr + '■';
			//tags += e.href;
			tags +=  e.href + '■';
			break;
		}
		e = e.parentNode;
	}
	
	var baseTarget;
	var baseArray = document.getElementsByTagName('target');
	var nLen = baseArray.length;
	tags += 'baseArray.length()=' + nLen;
	var i = 0;
	
	while (nLen > i)
	{
		e = baseArray[i];
		
		//if (e.href)
		{
			tagNameStr = e.tagName;
			tagNameStr = tagNameStr.toLowerCase();
			tags +=  tagNameStr + '■';
			//tags += e.href;
			tags +=  e.href + '■';
			//break;
		}
		//e = e.parentNode;
		i = i+1;
	}
	
	var targets = MyIPhoneApp_ModifyLinkTargets();
	tags += '■MyIPhoneApp_ModifyLinkTargets' + targets;
	
	return tags;
}

function MyIPhoneApp_ModifyLinkTargets()
{
	var tags = "";
	var tagsHref = "";
	var nBlanks = 0;
	var allLinks = document.getElementsByTagName('a');
	tags += 'allLinks length =[' + allLinks.length + ']=>_blank length=[';
	if (allLinks) {
		var i;
		for (i=0; i<allLinks.length; i++) {
			var link = allLinks[i];
			var target = link.getAttribute('target');
			if (target && target == '_blank') {
				nBlanks = nBlanks + 1;
				link.setAttribute('target','_self');
				//link.style.webkitTouchCallout = 'none';
				//tagsHref +=  link.href + '■';
				tagsHref +=  link.tagName + '■';
				tagsHref +=  link.href + '■';
				tagsHref +=  link.text + '■';
			}
		}
	}
	tags += nBlanks + ']■' + 'tagsHref:' + tagsHref;
	
	var frames = document.getElementsByTagName('iframe');
	tags += '■' + 'iframe:' + frames.length;
	frames.style.webkitTouchCallout = 'none';
	for (i=0; i<frames.length; i++)
	{
		var fObject = frames[i];
		var framesALinks = fObject.getElementsByTagName('a');
		tags += 'frames[i=' + i + '] length =[' + framesALinks.length + ']';
	}
	
	return tags;
}
