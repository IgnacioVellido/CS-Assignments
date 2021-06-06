/**
 * Captura de los nombres de los jugadores de Qytetet
 */

package GUIQytetet;

import java.awt.Color;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import javax.swing.BorderFactory;
import javax.swing.border.Border;

/**
 * @author Ana Anaya
 */

public class CapturaNombreJugadores extends javax.swing.JDialog {


    private ArrayList<String> nombres = new ArrayList();
    public CapturaNombreJugadores(java.awt.Frame parent, boolean modal) {
        super(parent, modal);
        initComponents();       
        this.addWindowListener (new WindowAdapter() {
            @Override
            public void windowClosing (WindowEvent e) {
                    System.exit(0);
            }
        });
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        nombreJ1 = new javax.swing.JTextField();
        nombreJ2 = new javax.swing.JTextField();
        nombreJ3 = new javax.swing.JTextField();
        nombreJ4 = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        numeroJ = new javax.swing.JTextField();
        labelJ1 = new javax.swing.JLabel();
        labelJ2 = new javax.swing.JLabel();
        labelJ3 = new javax.swing.JLabel();
        labelJ4 = new javax.swing.JLabel();
        jbJugar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Nombre de los jugadores");

        nombreJ1.setEditable(false);

        nombreJ2.setEditable(false);
        nombreJ2.setText(" ");

        nombreJ3.setEditable(false);
        nombreJ3.setText(" ");

        nombreJ4.setEditable(false);
        nombreJ4.setText(" ");

        jLabel1.setText("Indica el número de jugadores y pulsa enter:");

        numeroJ.setText(" ");
        numeroJ.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                numeroJActionPerformed(evt);
            }
        });

        labelJ1.setText("Jugador 1");
        labelJ1.setEnabled(false);

        labelJ2.setText("Jugador 2");
        labelJ2.setEnabled(false);

        labelJ3.setText("Jugador 3");
        labelJ3.setEnabled(false);

        labelJ4.setText("Jugador 4");
        labelJ4.setEnabled(false);

        jbJugar.setText("¡ JUGAR !");
        jbJugar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbJugarActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                        .addGap(31, 31, 31)
                        .addComponent(jLabel1)
                        .addGap(3, 3, 3)
                        .addComponent(numeroJ))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(52, 52, 52)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(labelJ1)
                            .addComponent(labelJ2)
                            .addComponent(labelJ3)
                            .addComponent(labelJ4))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 68, Short.MAX_VALUE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(nombreJ4, javax.swing.GroupLayout.PREFERRED_SIZE, 173, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(nombreJ3, javax.swing.GroupLayout.PREFERRED_SIZE, 173, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(nombreJ2, javax.swing.GroupLayout.PREFERRED_SIZE, 173, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(nombreJ1, javax.swing.GroupLayout.PREFERRED_SIZE, 173, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                        .addGap(129, 129, 129)
                        .addComponent(jbJugar, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addGap(38, 38, 38))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(numeroJ, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(31, 31, 31)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(nombreJ1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(labelJ1))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(nombreJ2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(labelJ2))
                        .addGap(18, 18, 18)
                        .addComponent(nombreJ3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(labelJ3))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(nombreJ4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(labelJ4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 27, Short.MAX_VALUE)
                .addComponent(jbJugar)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jbJugarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbJugarActionPerformed
        nombres.add(nombreJ1.getText());
        nombres.add(nombreJ2.getText());
        if(Integer.parseInt(numeroJ.getText().trim()) >= 3)
            nombres.add(nombreJ3.getText());
        if(Integer.parseInt(numeroJ.getText().trim()) ==4)
            nombres.add(nombreJ4.getText());
        this.dispose();
    }//GEN-LAST:event_jbJugarActionPerformed

    private void numeroJActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_numeroJActionPerformed
        int numJugadores;
        
        try{
            numJugadores = Integer.parseInt(numeroJ.getText().trim());
            if(numJugadores>4)
            {
                numJugadores=4;
                numeroJ.setText(" 4");
            }
        }catch(NumberFormatException ex){
            numJugadores = 0;
        }

        switch(numJugadores)
        {
            case 2:
                numeroJ.setBorder(BorderFactory.createLineBorder(Color.DARK_GRAY));
                nombreJ1.setEditable(true);
                labelJ1.setEnabled(true);
                nombreJ2.setEditable(true);
                labelJ2.setEnabled(true);
                nombreJ3.setEditable(false);
                labelJ3.setEnabled(false);
                nombreJ4.setEditable(false);
                labelJ4.setEnabled(false);
            break;
            case 3:
                numeroJ.setBorder(BorderFactory.createLineBorder(Color.DARK_GRAY));
                nombreJ1.setEditable(true);
                labelJ1.setEnabled(true);
                nombreJ2.setEditable(true);
                labelJ2.setEnabled(true);
                nombreJ3.setEditable(true);
                labelJ3.setEnabled(true);
                nombreJ4.setEditable(false);
                labelJ4.setEnabled(false);
            break;
            case 4:
                numeroJ.setBorder(BorderFactory.createLineBorder(Color.DARK_GRAY));
                nombreJ1.setEditable(true);
                labelJ1.setEnabled(true);
                nombreJ2.setEditable(true);
                labelJ2.setEnabled(true);
                nombreJ3.setEditable(true);
                labelJ3.setEnabled(true);
                nombreJ4.setEditable(true);
                labelJ4.setEnabled(true);
            break;
            default:
                numeroJ.setBorder(BorderFactory.createLineBorder(Color.red));  
                nombreJ1.setEditable(false);
                labelJ1.setEnabled(false);
                nombreJ2.setEditable(false);
                labelJ2.setEnabled(false);
                nombreJ3.setEditable(false);
                labelJ3.setEnabled(false);
                nombreJ4.setEditable(false);
                labelJ4.setEnabled(false); 
            break;
        }
    }//GEN-LAST:event_numeroJActionPerformed


    public ArrayList<String> obtenerNombres() {
        this.setVisible(true);
        return nombres;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JButton jbJugar;
    private javax.swing.JLabel labelJ1;
    private javax.swing.JLabel labelJ2;
    private javax.swing.JLabel labelJ3;
    private javax.swing.JLabel labelJ4;
    private javax.swing.JTextField nombreJ1;
    private javax.swing.JTextField nombreJ2;
    private javax.swing.JTextField nombreJ3;
    private javax.swing.JTextField nombreJ4;
    private javax.swing.JTextField numeroJ;
    // End of variables declaration//GEN-END:variables
}
