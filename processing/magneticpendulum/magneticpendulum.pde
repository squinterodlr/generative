PVector position, previous_pos;
PVector velocity;
PVector force;

int frame = 0;
int max_particles = 5;
int current_particles = 0;
PVector[] position_list = new PVector[max_particles];
PVector[] velocity_list = new PVector[max_particles];


int n_charges = 3;

float size_x = 15;
float size_y = 15;
PVector world_size = new PVector(size_x,size_y);
PVector world_scale;


float charge = 1;
float gravity = 1;
float drag_coefficient = 0.05;
float distance_threshold = 0.1;
float h = 0.0105;
float power = 1.5;
float r = 1.0;

float angle = 0;
float omega = PI;
float dt = 1.0/(float(60*5));

PVector[] charge_list = new PVector[n_charges];

PShader cshader;

PVector world_to_screen(PVector world_vec){

    PVector screen_vec = PVector.add(world_vec,PVector.mult(world_size,0.5));

    screen_vec.x = screen_vec.x*world_scale.x;
    screen_vec.y = screen_vec.y*world_scale.y;

    return screen_vec;
    
}

PVector screen_to_world(PVector screen_vec){

    PVector world_vec = new PVector(screen_vec.x/world_scale.x,screen_vec.y/world_scale.y);

    world_vec.sub(PVector.mult(world_size,0.5));

    return world_vec;
    
}

PVector electric_force(PVector charge_pos, PVector test_pos,float charge){

    PVector direction = PVector.sub(charge_pos,test_pos);
    float distance = direction.mag();

    float magnitude = charge/((float)Math.pow(distance*distance + h*h,power));

    return PVector.mult(direction,magnitude);

}

PVector calculate_forces(PVector pos, PVector vel){

    PVector force = new PVector(0,0);

    for (int i = 0; i < n_charges; ++i) {
        force.add(electric_force(charge_list[i],pos,charge));
    }
    force.sub(PVector.mult(pos,gravity));
    force.sub(PVector.mult(vel,drag_coefficient));

    return force;

}

void move(PVector pos, PVector vel){

    PVector pos_k1, pos_k2, pos_k3, pos_k4;
    PVector vel_k1, vel_k2, vel_k3, vel_k4;
    PVector dpos, dvel;
    
    
    vel_k1 = calculate_forces(pos,vel);
    pos_k1 = vel;

    vel_k2 = calculate_forces(PVector.add(pos,PVector.mult(pos_k1,0.5*dt)),
                              PVector.add(vel,PVector.mult(vel_k1,0.5*dt)));
    pos_k2 = PVector.add(vel,PVector.mult(vel_k1,0.5*dt));

    vel_k3 = calculate_forces(PVector.add(pos,PVector.mult(pos_k2,0.5*dt)),
                              PVector.add(vel,PVector.mult(vel_k2,0.5*dt)));
    pos_k3 = PVector.add(vel,PVector.mult(vel_k2,0.5*dt));    

    vel_k4 = calculate_forces(PVector.add(pos,PVector.mult(pos_k3,dt)),
                              PVector.add(vel,PVector.mult(vel_k3,dt)));
    pos_k4 = PVector.add(vel,PVector.mult(vel_k3,dt));

    dpos = PVector.add(pos_k1,PVector.mult(pos_k2,2.0));
    dpos.add(PVector.mult(pos_k3,2.0));
    dpos.add(pos_k4);
    dpos.mult(dt/6.0);
    pos.add(dpos);

    dvel = PVector.add(vel_k1,PVector.mult(vel_k2,2.0));
    dvel.add(PVector.mult(vel_k3,2.0));
    dvel.add(vel_k4);
    dvel.mult(dt/6.0);
    vel.add(dvel);
    
    /*
    dvel = PVector.mult(calculate_forces(pos,vel),dt);
    dpos = PVector.mult(vel,dt);
    pos.add(dpos);
    vel.add(dvel);
    */
}

void draw_charges(){

    PVector this_charge;
    ellipseMode(RADIUS);
    fill(0,0,0,255);
    for (int i = 0; i < n_charges; ++i) {
        this_charge = charge_list[i].copy();
        this_charge = world_to_screen(this_charge);
        ellipse(this_charge.x, this_charge.y, 10, 10);
    }

}


/*void mousePressed() {

    position_list[current_particles] = screen_to_world(new PVector(mouseX,mouseY));
    velocity_list[current_particles] = new PVector(0,0);

    current_particles += 1;
    current_particles = current_particles%max_particles;
    println("Particle added.");
}
*/


void setup(){

    size(1440,1440,P3D);


    //println("blah");
    world_scale = new PVector(width/world_size.x, height/world_size.y);

    ellipseMode(RADIUS);
    //println("Blah");
    for (int i = 0; i < n_charges; ++i) {
        charge_list[i] =  new PVector(cos(TWO_PI*i/n_charges),sin(TWO_PI*i/n_charges));
    }
    cshader = loadShader("pendulumshader.glsl");
    cshader.set("resolution",width,height);
    cshader.set("size",world_size.x,world_size.y);
    //cshader.set("mouse",mouseX,mouseY);
    //cshader.set("scale",world_scale.x,world_scale.y);
    cshader.set("distance_threshold",distance_threshold);
    cshader.set("dt",dt);
    cshader.set("charge",charge);
    cshader.set("gravity",gravity);
    cshader.set("drag",drag_coefficient);
    cshader.set("h",h);
    cshader.set("power",power);
    cshader.set("n_charges",n_charges);
    cshader.set("r",r);
    shader(cshader);
    //noLoop();
}


void draw(){

    fill(255);
    rect(0, 0, width, height);
    println("Rendering...");

    cshader.set("h",h + (0.316-h)*cos(angle)*cos(angle));
    shader(cshader);
    println("Done...");
    //background(255);
    //draw_charges();
    if (angle < omega){
        
        saveFrame(String.format("frames/magnetic_pendulum_%d_%04d.png",n_charges,frame));
        angle += omega*dt;
        frame += 1;
    }

    if(current_particles == 0){ return;}

    PVector this_pos, this_vel;

    for (int i = 0; i < current_particles; ++i) {

        this_pos = position_list[i].copy();
        this_vel = velocity_list[i].copy();

        move(this_pos,this_vel);
        //line(position_list[i].x, position_list[i].y, this_pos.x, this_pos.y);
        
        position_list[i] = this_pos.copy();
        velocity_list[i] = this_vel.copy();

        ellipseMode(RADIUS);
        this_pos = world_to_screen(this_pos);
        fill(0);
        ellipse(this_pos.x,this_pos.y,5,5);
    }        

}
