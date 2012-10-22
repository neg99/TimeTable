import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.util.Enumeration;
import java.util.Vector;


public class RowHeaderTable extends MultiSpanCellTable {
    RowHeaderTable(String[][] Data) {
        DefaultTableModel headerData = new DefaultTableModel(0, 1);
        MyTableModel data = new MyTableModel(0, Data[0].length - 1);

        for (int i = 1; i < Data.length; i++) {
            headerData.addRow(new Object[]{Data[i][0]});

            Vector v = new Vector();

            for (int j = 1; j < Data[i].length; j++)
                v.add(Data[i][j]);

            data.addRow(v);
        }
        //data.cellAtt.combine(new int[]{3}, new int[]{0, 1, 2});

        JTable table = new JTable(data);

        table.setUI(new MultiSpanCellTableUI());
        for (int i = 1; i < Data[0].length; i++) {
            table.getColumnModel().getColumn(i - 1).setHeaderValue(Data[0][i]);
        }
        //AttributiveCellTableModel ml = new AttributiveCellTableModel(10,6);
        //CellSpan cellAtt =(CellSpan)ml.getCellAttribute();
        for (int i = 0; i < Data.length; i++) {
            for (int j = 0; j < Data[i].length; j++) {
                if (Data[i][j] != null && Data[i][j].equals("<---")) {
                    int[] rows = {i};
                    int[] columns = {j - 1, j};
                    //cellAtt.combine(rows,columns);
                }
            }
        }

        table.setRowSelectionAllowed(true);
        table.setColumnSelectionAllowed(true);
        table.getTableHeader().setReorderingAllowed(false);
        JTable rowHeader = new JTable(headerData) {
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        //table = new JTable(model)

        LookAndFeel.installColorsAndFont
                (rowHeader, "TableHeader.background",
                        "TableHeader.foreground", "TableHeader.font");


        rowHeader.setIntercellSpacing(new Dimension(0, 0));
        Dimension d = rowHeader.getPreferredScrollableViewportSize();
        d.width = rowHeader.getPreferredSize().width;
        rowHeader.setPreferredScrollableViewportSize(d);
        rowHeader.setRowHeight(table.getRowHeight());
        rowHeader.setDefaultRenderer(Object.class, new RowHeaderRenderer());
        rowHeader.setRowSelectionAllowed(false);
        rowHeader.setColumnSelectionAllowed(false);
        rowHeader.setFocusable(false);
        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.setRowHeaderView(rowHeader);
        new RowHeaderResizer(scrollPane).setEnabled(true);
        JTableHeader corner = rowHeader.getTableHeader();
        corner.setReorderingAllowed(false);
        corner.setResizingAllowed(false);
        corner.setForeground(Color.WHITE);
        corner.setBackground(Color.WHITE);
        scrollPane.setCorner(JScrollPane.UPPER_LEFT_CORNER, corner);


        JFrame f = new JFrame("Row Header Test");
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.getContentPane().add(scrollPane, BorderLayout.CENTER);

        f.pack();
        f.setLocation(200, 100);
        f.setVisible(true);

    }

    public Rectangle getCellRect(int row, int column, boolean includeSpacing) {
        Rectangle sRect = super.getCellRect(row, column, includeSpacing);
        if ((row < 0) || (column < 0) ||
                (getRowCount() <= row) || (getColumnCount() <= column)) {
            return sRect;
        }
        CellSpan cellAtt = (CellSpan) ((MyTableModel) getModel()).getCellAttribute();
        if (!cellAtt.isVisible(row, column)) {
            int temp_row = row;
            int temp_column = column;
            row += cellAtt.getSpan(temp_row, temp_column)[CellSpan.ROW];
            column += cellAtt.getSpan(temp_row, temp_column)[CellSpan.COLUMN];
        }
        int[] n = cellAtt.getSpan(row, column);

        int index = 0;
        int columnMargin = getColumnModel().getColumnMargin();
        Rectangle cellFrame = new Rectangle();
        int aCellHeight = rowHeight + rowMargin;
        cellFrame.y = row * aCellHeight;
        cellFrame.height = n[CellSpan.ROW] * aCellHeight;

        Enumeration enumeration = getColumnModel().getColumns();
        while (enumeration.hasMoreElements()) {
            TableColumn aColumn = (TableColumn) enumeration.nextElement();
            cellFrame.width = aColumn.getWidth() + columnMargin;
            if (index == column) break;
            cellFrame.x += cellFrame.width;
            index++;
        }
        for (int i = 0; i < n[CellSpan.COLUMN] - 1; i++) {
            TableColumn aColumn = (TableColumn) enumeration.nextElement();
            cellFrame.width += aColumn.getWidth() + columnMargin;
        }


        if (!includeSpacing) {
            Dimension spacing = getIntercellSpacing();
            cellFrame.setBounds(cellFrame.x + spacing.width / 2,
                    cellFrame.y + spacing.height / 2,
                    cellFrame.width - spacing.width,
                    cellFrame.height - spacing.height);
        }
        return cellFrame;
    }


    private int[] rowColumnAtPoint(Point point) {
        int[] retValue = {-1, -1};
        int row = point.y / (rowHeight + rowMargin);
        if ((row < 0) || (getRowCount() <= row)) return retValue;
        int column = getColumnModel().getColumnIndexAtX(point.x);

        CellSpan cellAtt = (CellSpan) ((MyTableModel) getModel()).getCellAttribute();

        if (cellAtt.isVisible(row, column)) {
            retValue[CellSpan.COLUMN] = column;
            retValue[CellSpan.ROW] = row;
            return retValue;
        }
        retValue[CellSpan.COLUMN] = column + cellAtt.getSpan(row, column)[CellSpan.COLUMN];
        retValue[CellSpan.ROW] = row + cellAtt.getSpan(row, column)[CellSpan.ROW];
        return retValue;
    }


    public int rowAtPoint(Point point) {
        return rowColumnAtPoint(point)[CellSpan.ROW];
    }

    public int columnAtPoint(Point point) {
        return rowColumnAtPoint(point)[CellSpan.COLUMN];
    }


    public void columnSelectionChanged(ListSelectionEvent e) {
        repaint();
    }

    public void valueChanged(ListSelectionEvent e) {
        int firstIndex = e.getFirstIndex();
        int lastIndex = e.getLastIndex();
        if (firstIndex == -1 && lastIndex == -1) { // Selection cleared.
            repaint();
        }
        Rectangle dirtyRegion = getCellRect(firstIndex, 0, false);
        int numCoumns = getColumnCount();
        int index = firstIndex;
        for (int i = 0; i < numCoumns; i++) {
            dirtyRegion.add(getCellRect(index, i, false));
        }
        index = lastIndex;
        for (int i = 0; i < numCoumns; i++) {
            dirtyRegion.add(getCellRect(index, i, false));
        }
        repaint(dirtyRegion.x, dirtyRegion.y, dirtyRegion.width, dirtyRegion.height);
    }
}
