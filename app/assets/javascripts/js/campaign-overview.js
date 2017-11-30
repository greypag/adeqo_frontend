/**
 * @author elee
 */

exportUrl = campaignOverviewGetUrl;

var aoColumns = [];
for(var i=0;i<10;i++){
	aoColumns.push({ "asSorting": [ "desc", "asc" ] });
}

var overviewTableOption = {
	// bFilter: false,
	/* http://datatables.net/release-datatables/examples/basic_init/dom.html */
	"sDom": '<"table-responsive"rt>pil',
	"aLengthMenu": page_option,
	"language": {
		"info": "Page _PAGE_ of _PAGES_",
		"lengthMenu": "No. of Rows: _MENU_",
		"paginate": {
			"previous": "<<",
			"next": ">>"
		},
		"emptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"oLanguage": {
		"sInfo": "Page _PAGE_ of _PAGES_",
		"sLengthMenu": "No. of Rows: _MENU_",
		"oPaginate": {
			"sPrevious": "<<",
			"sNext": ">>"
		},
		"sEmptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"processing": true,
	"serverSide": true,
	"ajax": {
		"url":exportUrl,
		"type":"POST",
		"data": function(d){
			d.start_date = $("#start_date").val();
			d.end_date = $("#end_date").val();
			d.campaign_type = $("#campaign_type").val();
			d.campaign_id = $("#campaign_id").val();
			d.network_id = $("#network_id").val();
			d.csv=0;

			exportData=d;

			return d;
		}
	},
	"fnDrawCallback": function( oSettings ) {
		$(".loading_container").hide();
		tableTopScrollbar();

		var dataBydate=oSettings.json.data;
		dataBydate.sort(function(a, b){
			var dateA=new Date(a[0]), dateB=new Date(b[0]);
			return dateA-dateB; //sort by date ascending
		})

		linechart_label=[];
		linechart_data=[];
		linechart_data['impressions']=[];
		linechart_data['clicks']=[];
		linechart_data['pub_cost']=[];
		linechart_data['avg_cpc']=[];
		linechart_data['ctr']=[];
		linechart_data['conversion']=[];
		linechart_data['conversion_rate']=[];
		linechart_data['cpa']=[];
		linechart_data['revenue']=[];

		for(var i in dataBydate){
			linechart_label.push(dataBydate[i][0]);
			linechart_data['impressions'].push(dataBydate[i][1]);
			linechart_data['clicks'].push(dataBydate[i][2]);
			linechart_data['pub_cost'].push(dataBydate[i][3]);
			linechart_data['avg_cpc'].push(dataBydate[i][4]);
			linechart_data['ctr'].push(dataBydate[i][5]);
			linechart_data['conversion'].push(dataBydate[i][6]);
			linechart_data['conversion_rate'].push(dataBydate[i][7]);
			linechart_data['cpa'].push(dataBydate[i][8]);
			linechart_data['revenue'].push(dataBydate[i][9]);
		}

		genLineChart('impressions','clicks');
    },

    "fnFooterCallback": function (nFoot, aData, mData, iStart, iEnd, aiDisplay) {

    	 var response = this.api().ajax.json();

    	 // console.log(response);

    	 nFoot.getElementsByTagName('th')[0].innerHTML = "Total of all "+response.total_count.toLocaleString('en')+" records";
    	 nFoot.getElementsByTagName('th')[1].innerHTML = accounting.formatNumber(response.total[1]);
    	 nFoot.getElementsByTagName('th')[2].innerHTML = accounting.formatNumber(response.total[2]);
    	 nFoot.getElementsByTagName('th')[3].innerHTML = accounting.formatNumber(response.total[3],2);
    	 nFoot.getElementsByTagName('th')[4].innerHTML = accounting.formatNumber(response.total[4],2);
    	 nFoot.getElementsByTagName('th')[5].innerHTML = accounting.formatNumber(response.total[5],2)+"%";
    	 nFoot.getElementsByTagName('th')[6].innerHTML = accounting.formatNumber(response.total[6]);
    	 nFoot.getElementsByTagName('th')[7].innerHTML = accounting.formatNumber(response.total[7],2)+"%";
    	 nFoot.getElementsByTagName('th')[8].innerHTML = accounting.formatNumber(response.total[8],2);
    	 nFoot.getElementsByTagName('th')[9].innerHTML = accounting.formatNumber(response.total[9],2);



    },

	"columnDefs": [
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data);
            },
            "targets": [1,2,6]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2);
            },
            "targets": [3,4,8,9]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2)+"%";
            },
            "targets": [5,7]
        }
    ],
    "aoColumns": aoColumns
};

var overviewTable;

$(document).ready(function(){
	overviewTable = $("#campaign-overview-table").on('preXhr.dt', function(e,settings,data){
		$(".loading_container").show();
	}).DataTable(overviewTableOption);
});

function getCampaignData(){
	overviewTable.draw();
}
