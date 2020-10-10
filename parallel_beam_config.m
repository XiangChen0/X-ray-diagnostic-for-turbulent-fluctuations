%plot for explaining the configuration of the diagnostic
Figure_Default_Setting;

figure;
hold on;
%grid on;
%% Plot a unit circle
dtheta=pi/100;
theta=0:dtheta:2*pi;
plot(cos(theta),sin(theta),'k');
axis equal;
axis off;

%% detector/camera coordinate
%rectangle('Position',[-1 1.1 2 0.1],'FaceColor',[0.91 0.41 0.17],'EdgeColor',[0.91 0.41 0.17]);
rectangle_center=[0 -1.1];
rectangle_length=2;
rectangle_width=0.1;
rectangle_pos=rectangle_center+ ...
              [-rectangle_length/2, -rectangle_width/2;
               +rectangle_length/2, -rectangle_width/2;
               +rectangle_length/2, +rectangle_width/2;
               -rectangle_length/2, +rectangle_width/2;
               -rectangle_length/2, -rectangle_width/2];

text_center=-1.25;

text_pos=[0,text_center];


%text_length=0.1*ones(n_angle,1);%[0.1, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1];

global_chord_x=repmat(-1:0.1:1,2,1);
global_chord_y=global_chord_x;
global_chord_y(1,:)=rectangle_center(2)+rectangle_width/2;
global_chord_y(2,:)=1;

meas_center=[0.5 0];
meas_radius=0.1;

n_angle=6;
ang=0:180/n_angle:180;%[0, 30, 60, 90, 120, 150, 180];

for ii=1:length(ang)
    
    %% fix the size of the figure, avoid the automatic resizing
    R = [cosd(ang(2)) -sind(ang(2)); sind(ang(2)) cosd(ang(2))];
    rectangle_pos_rot=rectangle_pos * R';
    %plot(rectangle_pos_rot(:,1),rectangle_pos_rot(:,2),'k');
    plot(rectangle_pos_rot(:,1),rectangle_pos_rot(:,2),'LineStyle','none');
    
    global_chord_head=[global_chord_x(1,:);global_chord_y(1,:)]'* R';
    global_chord_tail=[global_chord_x(2,:);global_chord_y(2,:)]'* R';
    global_chord_x_rot=[global_chord_head(:,1) global_chord_tail(:,1)]';
    global_chord_y_rot=[global_chord_head(:,2) global_chord_tail(:,2)]';
    plot(global_chord_x_rot,global_chord_y_rot,'LineStyle','none');
     
    %% Local chords positions
    local_chord_x=repmat(meas_center(1)*cosd(ang(ii))-2*meas_radius: ...
                  0.05:meas_center(1)*cosd(ang(ii))+2*meas_radius,2,1);
    local_chord_y=local_chord_x;
    local_chord_y(1,:)=rectangle_center(2)+rectangle_width/2;
    local_chord_y(2,:)=1;
    
    global_chord_x_cp=global_chord_x;
    global_chord_y_cp=global_chord_y;
    indx=find(abs(global_chord_x(1,:)-meas_center(1)*cosd(ang(ii)))<=2*meas_radius);
    global_chord_x_cp(:,indx)=[];
    global_chord_y_cp(:,indx)=[];
         
    if ii==5 %change ii to get the configuration at different angles (from 1 to n_angle+1)
        
         R = [cosd(ang(ii)) -sind(ang(ii)); sind(ang(ii)) cosd(ang(ii))];
         rectangle_pos_rot=rectangle_pos * R';
         %plot(rectangle_pos_rot(:,1),rectangle_pos_rot(:,2),'k');
         fill(rectangle_pos_rot(:,1),rectangle_pos_rot(:,2),[0.91 0.41 0.17]);

         text_pos_rot=text_pos * R';
         text(text_pos_rot(1)-0.05,text_pos_rot(2),['C',num2str(ii)]);
    
    %% Plot chords
    
         global_chord_head=[global_chord_x_cp(1,:);global_chord_y_cp(1,:)]'* R';
         global_chord_tail=[global_chord_x_cp(2,:);global_chord_y_cp(2,:)]'* R';
         global_chord_x_rot=[global_chord_head(:,1) global_chord_tail(:,1)]';
         global_chord_y_rot=[global_chord_head(:,2) global_chord_tail(:,2)]';

         plot(global_chord_x_rot,global_chord_y_rot,'Color',[1 0.4 0.4]);
         
         local_chord_head=[local_chord_x(1,:);local_chord_y(1,:)]'* R';
         local_chord_tail=[local_chord_x(2,:);local_chord_y(2,:)]'* R';
         local_chord_x_rot=[local_chord_head(:,1) local_chord_tail(:,1)]';
         local_chord_y_rot=[local_chord_head(:,2) local_chord_tail(:,2)]';

         plot(local_chord_x_rot,local_chord_y_rot,'Color',[0.2 0.6 1]);
    
    end
    
end

%% Region of interest

fill(meas_center(1)+meas_radius*cos(theta),meas_center(2)+meas_radius*sin(theta),'y');
meas_x=meas_center(1)-meas_radius:2*meas_radius/5:meas_center(1)+meas_radius;
meas_y=meas_x;
meas_y(:)=meas_center(2);
plot(meas_x,meas_y,'k.','MarkerSize',8,'Color',[1 0 1]);