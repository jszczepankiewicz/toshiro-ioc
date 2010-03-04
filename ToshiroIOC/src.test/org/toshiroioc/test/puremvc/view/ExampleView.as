package org.toshiroioc.test.puremvc.view
{
	import mx.containers.Panel;
	import mx.controls.DataGrid;
	import mx.controls.Label;

	public class ExampleView extends Panel
	{
		public var view_grid : DataGrid;
		public var view_lbl : Label;
		public var view_lbl2 : Label;
		
		public function ExampleView()
		{
			super();
			view_grid = new DataGrid();
			addChild(view_grid);
			view_lbl = new Label();
			addChild(view_lbl);
			view_lbl2 = new Label();
			addChild(view_lbl2);
			/* view_grid.percentWidth = 100;
			view_grid.percentHeight = 100;
			var column : DataGridColumn = new DataGridColumn("View Grid");
			view_grid.columns = [column]; */
			
		}
		
	}
}

/* <mx:DataGrid id="view_grid" width="100%" height="100%">
		<mx:columns>
			<mx:DataGridColumn dataField="label" headerText="View Grid"/>
		</mx:columns>
	</mx:DataGrid>
	
	<mx:Label id="view_lbl" width="100%"  color="#125A69" fontWeight="bold" fontSize="14" alpha="1.0" textAlign="center"/> */