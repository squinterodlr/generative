#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 scale;
uniform vec2 size;
uniform vec2 mouse;

uniform float distance_threshold;
uniform float dt ;
uniform float charge;
uniform float gravity;
uniform float drag;
uniform float h;
uniform	float power;
uniform int n_charges;
uniform float r;

#define M_PI 3.1415926535897932384626433832795
const float TWO_PI = 2.0*M_PI;

const int maxSteps = 20000;
const float speed_threshold = 0.05;
const int closeness_steps_threshold = 500;


float redBallArc = 0;
float blueBallArc =  2*M_PI / 3.;
float yellowBallArc = 4.* M_PI / 3.;


const vec4 ice_cream[5] = vec4[5](vec4(164.,  22.,  35.,255.)/255.,
						          vec4(153., 225., 217.,255.)/255.,
						          vec4(240., 247., 244.,255.)/255.,
								  vec4(112., 171., 175.,255.)/255.,
								  vec4( 91.,  80., 122.,255.)/255.);


const vec4 turquoise[5] = vec4[5](vec4(193., 207., 218., 255.)/255.,
								  vec4( 32., 164., 243., 255.)/255.,
								  vec4(  8., 196., 177., 255.)/255.,
								  vec4(148.,  28.,  47., 255.)/255.,
								  vec4( 89.,  41.,  65., 255.)/255.);

const vec4 big_dip[5] = vec4[5](vec4(122., 83., 130., 255.)/255.,
							vec4(54., 21, 56, 255.)/255.,
							vec4( 156., 16., 62., 255.)/255.,
							vec4(173., 153., 168., 255.)/255.,
							vec4( 112., 3., 83., 255.)/255.);



const vec4 uhh[5] = vec4[5](vec4(38., 70., 83., 255.)/255.,
							vec4(42., 157., 143., 255.)/255.,
							vec4( 233., 196., 106., 255.)/255.,
							vec4(244., 162., 97., 255.)/255.,
							vec4( 231., 111., 81., 255.)/255.);


vec4 pallete[] = big_dip;
vec2 balls[5];
/*
for (int i = 0; i < n_charges; i++){

	float angle = TWO_PI*i/n_charges;
	balls[i] = vec2(r*cos(angle), r*sin(angle));
}
*/


/*
vec2 redBall = vec2(r*cos(redBallArc), r*sin(redBallArc));	
vec2 blueBall = vec2(r*cos(blueBallArc), r*sin(blueBallArc));	
vec2 yellowBall = vec2(r*cos(yellowBallArc), r*sin(yellowBallArc));


vec4 redColor = turquoise[0];
vec4 blueColor = turquoise[1];
vec4 yellowColor = turquoise[2];
*/
vec2 electricForce(vec2 charge, vec2 pendulum, float q,float power)
{
	vec2 separation = charge-pendulum;
	float dist_sq = dot(separation, separation);
		
	return (q/pow(dist_sq + h*h,power))*(separation);
}

vec2 screen_to_world(vec2 screenvec){
	
	vec2 pos = vec2(screenvec.x,screenvec.y);
	pos /= scale;
	pos -= size;

	return pos;
	
}

vec2 getForces(vec2 pendulum, vec2 velocity,float power){
	
	vec2 force = vec2(0.,0.);
	
	for (int i = 0; i < n_charges; i++){
		force += electricForce(balls[i],pendulum,charge,power);
	}
	
	force -= gravity*pendulum;
	force -= drag*velocity;
	
	return force;
	
}



void main( void ) {
	
	vec4 color;
	vec2 pos = gl_FragCoord.xy;
	pos /= resolution;
	pos.x *= size.x;
	pos.x -= 0.5*size.x;

	pos.y *= size.y;
	pos.y -= 0.5*size.y;
	
	for (int i = 0; i < n_charges; i++){

		float angle = TWO_PI*(float(i)+0.5)/n_charges;
		balls[i] = vec2(r*cos(angle), r*sin(angle));
	}


	vec2 currentPos = pos;
	
	for (int i = 0; i < n_charges; i++){

		if (distance(currentPos,balls[i]) < 0.5*distance_threshold){
		color = pallete[i];
		gl_FragColor = color;
		return;
		}
	}
	/*
	if (distance(currentPos,redBall) < 0.5*distance_threshold){
		color = redColor;
		gl_FragColor = color;
		return;
	}
	if (distance(currentPos,blueBall) < 0.5*distance_threshold){
		color = blueColor;
		gl_FragColor = color;
		return;
		
	}
	if (distance(currentPos,yellowBall) < 0.5*distance_threshold){
		color = yellowColor;
		gl_FragColor = color;
		return;
	}
	*/
	
	vec2 currentVel = vec2(0.,0.);
	
	vec2 pos_k1, pos_k2, pos_k3, pos_k4;
	vec2 vel_k1, vel_k2, vel_k3, vel_k4;
	
	int n_steps = 0;
	int close_steps = 0;
	bool close = false;
	bool stop = false;

	for (int i = 0; i < maxSteps; i++){
		
		if(stop){break;}

		close = false;
		n_steps = i;
		vel_k1 = getForces(currentPos,currentVel,power);
		pos_k1 = currentVel;
		
		vel_k2 = getForces(currentPos + 0.5*dt*pos_k1, currentVel + 0.5*h*vel_k1,power);
		pos_k2 = currentVel + 0.5*h*vel_k1;

		vel_k3 = getForces(currentPos + 0.5*dt*pos_k2, currentVel + 0.5*h*vel_k2,power);
		pos_k3 = currentVel + 0.5*h*vel_k2;
		
		vel_k4 = getForces(currentPos + dt*pos_k3, currentVel + h*vel_k3,power);
		pos_k4 = currentVel + h*vel_k3;
		
		currentPos += (dt/6.)*(pos_k1 + 2.*pos_k2 + 2.*pos_k3 + pos_k4);
		currentVel += (dt/6.)*(vel_k1 + 2.*vel_k2 + 2.*vel_k3 + vel_k4);
		
		for (int i = 0; i < n_charges; i++){

			if (distance(currentPos,balls[i]) < 0.5*distance_threshold){
				close_steps++;
				close = true;
				if (close_steps >= closeness_steps_threshold){
					color = pallete[i];
					stop = true;
					break;
				}	
			}
		}

		if(!close){
			close_steps = 0;
		}
		

		
	}
	float t = float(n_steps)/float(maxSteps);
	t= pow(t,2.);
	
	
	gl_FragColor = (1.-t)*color + t*vec4(0.,0.,0.,1.);


	
}
