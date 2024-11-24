import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TotalRevenueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresos Totales',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            '\$450,000',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                'Últimos 30 días',
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
              SizedBox(width: 4.0),
              Text(
                '+12%',
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          _buildLineChart(),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Ejemplo de título en la parte superior
                  return Text(
                    '$value',
                    style: TextStyle(fontSize: 10.0, color: Colors.blue),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Ejemplo de título en el lado derecho
                  return Text(
                    '$value',
                    style: TextStyle(fontSize: 10.0, color: Colors.red),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36, // Ajusta el espacio reservado
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(), // Ejemplo de número
                    style: TextStyle(
                        fontSize: 10.0), // Ajusta el tamaño de la fuente aquí
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text('01/09', style: TextStyle(fontSize: 10.0));
                    case 2:
                      return Text('02/09', style: TextStyle(fontSize: 10.0));
                    case 3:
                      return Text('03/09', style: TextStyle(fontSize: 10.0));
                    case 4:
                      return Text('04/09', style: TextStyle(fontSize: 10.0));
                    case 5:
                      return Text('05/09', style: TextStyle(fontSize: 10.0));
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(1, 1),
                FlSpot(2, 1.5),
                FlSpot(3, 1.2),
                FlSpot(4, 2.2),
                FlSpot(5, 1.8),
              ],
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: [
                FlSpot(1, 1.3),
                FlSpot(2, 1.8),
                FlSpot(3, 1.5),
                FlSpot(4, 2.5),
                FlSpot(5, 2.0),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: [
                FlSpot(1, 2),
                FlSpot(2, 2.2),
                FlSpot(3, 2.1),
                FlSpot(4, 2.7),
                FlSpot(5, 2.3),
              ],
              isCurved: true,
              color: Colors.teal,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
