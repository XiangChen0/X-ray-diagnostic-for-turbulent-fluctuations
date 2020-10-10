%plot for explaining the configuration of the diagnostic
Figure_Default_Setting;

figure;
hold on;
%grid on;
%Plot a unit circle
dtheta=pi/100;
theta=0:dtheta:2*pi;
plot(cos(theta),sin(theta),'k');
axis equal;
meas_center=[0.5 0];
meas_radius=0.1;

axis off;
camera_box_center=1+0.2;
camera_box_length=0.2;
camera_box_width=0.25;
camera_triangle_height=0.05;
text_center=1.4;
box_pos=[camera_box_center-camera_box_length/2, +camera_box_width/2;
         camera_box_center-camera_box_length/2, -camera_box_width/2;
         camera_box_center+camera_box_length/2, -camera_box_width/2;
         camera_box_center+camera_box_length/2, +camera_box_width/2;
         camera_box_center-camera_box_length/2, +camera_box_width/2];
triangle_pos=[camera_box_center-camera_box_length/2-camera_triangle_height, +camera_box_width/2;
              camera_box_center-camera_box_length/2-camera_triangle_height, -camera_box_width/2;
              camera_box_center-camera_box_length/2, 0;
              camera_box_center-camera_box_length/2-camera_triangle_height, +camera_box_width/2];
text_pos=[text_center,0];

ang=[-90, -45, 0, 45, 90];

for ii=1:length(ang)
    R = [cosd(ang(ii)) -sind(ang(ii)); sind(ang(ii)) cosd(ang(ii))];
    box_pos_rot=box_pos * R';
    triangle_pos_rot=triangle_pos * R';
    text_pos_rot=text_pos * R';
    
    plot(box_pos_rot(:,1),box_pos_rot(:,2),'k');
    plot(triangle_pos_rot(:,1),triangle_pos_rot(:,2),'k');
    text(text_pos_rot(1),text_pos_rot(2),['camera',num2str(ii)]);
    chord_center=(meas_center(1)-triangle_pos_rot(3,1))+1i*(meas_center(2)-triangle_pos_rot(3,2));
    angle_center=rad2deg(angle(chord_center));
    angle_center=mod(angle_center,360);
    %disp(mod(angle_center,360));
    dangle_local=1;
    N_local=5;
    dangle_global=7;
    N_global=20;
    angle_local=angle_center+(-N_local*dangle_local:dangle_local:N_local*dangle_local);
    angle_global=angle_center+(-N_global*dangle_global:dangle_global:N_global*dangle_global);
    angle_global(angle_global<rad2deg(acos(1/triangle_pos(3,1)))+ang(ii)+90)=[];
    angle_global(angle_global>270-rad2deg(acos(1/triangle_pos(3,1)))+ang(ii))=[];
    angle_global(angle_global<=max(angle_local) & angle_global>=min(angle_local))=[];
    
    if ii==4
        alpha_local=angle_local-asind(triangle_pos(3,1)*sind(angle_local-ang(ii)));
        plot([triangle_pos_rot(3,1)*ones(1,length(angle_local));cosd(alpha_local)],...
             [triangle_pos_rot(3,2)*ones(1,length(angle_local));sind(alpha_local)],'b');
        alpha_global=angle_global-asind(triangle_pos(3,1)*sind(angle_global-ang(ii)));
        plot([triangle_pos_rot(3,1)*ones(1,length(angle_global));cosd(alpha_global)],...
             [triangle_pos_rot(3,2)*ones(1,length(angle_global));sind(alpha_global)],'r');
       %{ 
       plot(triangle_pos_rot(3,1)+[zeros(1,length(angle_local));2.2*cosd(angle_local)], ...
            triangle_pos_rot(3,2)+[zeros(1,length(angle_local));2.2*sind(angle_local)],'b');
       plot(triangle_pos_rot(3,1)+[zeros(1,length(angle_global));2.2*cosd(angle_global)], ...
            triangle_pos_rot(3,2)+[zeros(1,length(angle_global));2.2*sind(angle_global)],'r');
        %}
    end
end


%Region of interest
fill(meas_center(1)+meas_radius*cos(theta),meas_center(2)+meas_radius*sin(theta),'y');

