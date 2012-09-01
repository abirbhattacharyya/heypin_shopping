
/* Configuration */

var itemsVisible = 20;   // initial items to show
var itemsToShow = 10;    // how much items show when end of page reached

var responsibility = 50;    // in millisecons from 1 to 1000
var showScrollerTop = 500;  // how much user should scroll page (px) to see scroller button

var columnWidth = 235;   // default column width

/* --- DONT CHANGE ANYTHING BELOW THIS LINE --- */

var columnCount = null;
var resizeTimer = null;

/* initialization */
jQuery(document).ready(function() {

    // initial column arrangement
    arrangeColumns();    
    // handling scroller
    jQuery('.scroller').click(function(){
        jQuery.smoothScroll();
        return false;
    });

});

/* window resize handler */

jQuery(window).bind('resize', function() {
    if (resizeTimer) clearTimeout(resizeTimer);
    resizeTimer = setTimeout(onResizeEvent, responsibility);
});

function onResizeEvent() {
    arrangeColumns();
}

/* window scroll handler */

jQuery(window).bind('scroll', function() {
    var windowHeight = jQuery(window).height();
    var scrollTop = jQuery(window).scrollTop();
    var heights = getColumnsHeights();
    var minColumnHeight = heights[getColumnNumWithMinHeight()];
    if(scrollTop + windowHeight >= minColumnHeight + 100) {
//        alert('add items from: '+itemsVisible+'; count: '+itemsToShow);
        fillColumns(itemsVisible, itemsToShow);
        itemsVisible += itemsToShow;
        /*
         * here you can use AJAX to add new items to the end of the stack...
         */
    }

    // show/hide scroller
    scroller = jQuery('.scroller');
    if(scrollTop > showScrollerTop) {
        scroller.show().css('top', scrollTop + windowHeight - scroller.height());
    } else {
        scroller.hide();
    }
});

/* --- */

function arrangeColumns()
{
    // calsulate column count
    windowWidth = jQuery(window).width();
    newColumnCount = Math.floor((windowWidth-20)/columnWidth);

    // align columns to the center of the page
    leftMargin = Math.floor(((windowWidth-20) - newColumnCount*columnWidth)/2);
    jQuery('.columns').css('padding-left', leftMargin+'px');

    // if columns count stayed the same, just leave them as is
    if(newColumnCount==columnCount) return;
    columnCount = newColumnCount;

    // remove old columns from DOM
    jQuery('.columns .column').remove();
    jQuery('.columns .manage').remove();

    for(i = 0; i < columnCount; i++) {
        jQuery('.columns').append('<div class="column num-'+i+'"><ul class="items"></ul></div>');
    }

    // fill columns with items
    fillColumns(0, itemsVisible);
}

function fillColumns(from, count)
{
    for(inum = from; inum < from + count; inum++) {
        c = getColumnNumWithMinHeight();
        cloneItemToColumn(inum, c);
    }
}

function getColumnsHeights() {
    chs = new Array();
    for(i = 0; i < columnCount; i++) {
        chs[i] = jQuery('.column.num-' + i).height();
    }
    return chs;
}

function getColumnNumWithMinHeight() {
    heights = getColumnsHeights();
    cmin = 999999999;
    cres = 0;
    for(i = 0; i < heights.length; i++) {
        if(heights[i] < cmin) {
            cmin = heights[i];
            cres = i;
        }
    }
    return cres;
}

function cloneItemToColumn(itemNum, colNum)
{
    stack = jQuery('.stack LI.item').clone();
    el = stack.get(itemNum);
    jQuery('.columns .column.num-'+colNum+' UL.items').append(el);
}

