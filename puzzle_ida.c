/*COMP20003 Assignment 2
Student Name: Shiyu Zhang
Student ID: 683557*/

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <math.h>
#include <assert.h>
#include <time.h>

#define FINALX  0
#define FINALY  0
#define PUZZLELEN 4
#define PUZZLEWID 4
#define ITERATOR 3
#define UP 0
#define DOWN 2
#define LEFT 1
#define RIGHT 3
#define INVALID_MOVE 6

/*Global counters*/
long int node_generated =0;
long int node_expanded = 0;

typedef struct search_node{
	int s[PUZZLEWID][PUZZLELEN]; //the matrix representing the puzzel's current state
	int blank_pos_x;//the x position of the blank block(ROW)
	int blank_pos_y;//the column position of the blank tile
	int g;//the cost to move from the inition state s0 to current state
	int f;//the eveluation function f(n)
	int last_move;//to store the number representing the last movement
}search_node;

/*This function take a 2D array as argumnent, and print out the value inside this
array in matrix format*/
void print(int matrix[PUZZLEWID][PUZZLELEN]){
	int i,j;
	for(i=0;i<=ITERATOR;i++){
		for(j=0;j<=ITERATOR;j++){
			printf("%d ", matrix[i][j]);
		}
		printf("\n");
	}
}
/*This function take in a matrix, the coordinate that wanted to change position, 
and the target coordinates
*/
void swap(int matrix[PUZZLEWID][PUZZLELEN], int orig_x, int orig_y, int to_x, int to_y){
	int temp=matrix[orig_x][orig_y];
	matrix[orig_x][orig_y] = matrix[to_x][to_y];
	matrix[to_x][to_y]= temp;
	
}
/*This function takes 2 matrixes of same size,and copy all the values in 
swapped matrix to next_s matrix
*/
void copy(int next_s[PUZZLEWID][PUZZLELEN], int swapped[PUZZLEWID][PUZZLELEN]){
	int i, j;
	for(i=0;i<=ITERATOR;i++){
		for(j=0;j<=ITERATOR;j++){
			next_s[i][j]=swapped[i][j];
		}
	}
}
/*
This function takes an 2D matrix(matrix) as its argument, calculate 
the Manhatton distance, and return it. Becuase it's the heuristic predition
for the solver for ida* search, it's named heuristic for easy understanding
*/
int heuristic(int matrix[PUZZLEWID][PUZZLELEN]){
	int x, y;
	int h=0;
	for(x=0; x<=ITERATOR;x++){
		for(y=0;y<=ITERATOR;y++){
			if(matrix[x][y]!=0){
				int goal_x= matrix[x][y]/PUZZLEWID;
				int goal_y = matrix[x][y]%PUZZLELEN;
				h+= abs(goal_x-x)+abs(goal_y-y);
			}
		}
	}
	return h;
}

/*This funtion takes two int argument and return the smaller one between them
*/
int min(int A, int B){
	if(A<B){
		return A;
	}
	else{
		return B;
	}
}

/*This function takes a pointer of a search node: node, an array of search node
move, as argument, calculate the possible movements of one generation of child
of this search node, if the blank block can't be moved, assign NULL to the
correspond possition in the move array, otherwise, move the blank block to the
desired position and put it into the array move
*/

void generate_move(search_node* node, search_node** move){
	int movement;
	for(movement=UP; movement<=ITERATOR; movement++){
		if( (movement==UP && node-> blank_pos_x-1<0) ||  
			(movement==UP && node->last_move==DOWN) ) {
			move[UP]=NULL;//can't move up or duplicate movement
		}
		else if( (movement==LEFT && node-> blank_pos_y-1<0) ||  
			(movement==LEFT && node->last_move==RIGHT) ){
			move[LEFT]=NULL; //can't move left or duplicate movement
		}
		else if( (movement==DOWN && node-> blank_pos_x+1>3) ||  
			(movement==DOWN && node->last_move==UP) ){
			move[DOWN]=NULL; //can't move down or duplicate movement
		}
		else if( (movement==RIGHT && node->blank_pos_y+1>3) ||  
			(movement==RIGHT && node->last_move==LEFT) ){
			move[RIGHT]=NULL; // can't move right or duplicate movement
		}
		else{
			if(movement==UP){
				//move up
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x-1, node->blank_pos_y);
				copy(move[UP]->s, node->s);
				move[UP]->blank_pos_x=node->blank_pos_x-1;
				move[UP]->blank_pos_y=node->blank_pos_y;
				move[UP]->last_move=UP;
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x-1, node->blank_pos_y);
				node_generated=node_generated+1;
				
			}

			else if(movement==LEFT){
				//move left
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x, node->blank_pos_y-1);
				copy(move[LEFT]->s, node->s);
				move[LEFT]->blank_pos_x=node->blank_pos_x;
				move[LEFT]->blank_pos_y=node->blank_pos_y-1;
				move[LEFT]->last_move=LEFT;
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x, node->blank_pos_y-1);
				node_generated=node_generated+1;
				
			}
			else if (movement==DOWN){
				//move down
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x+1, node->blank_pos_y);
				copy(move[DOWN]->s, node->s);
				move[DOWN]->blank_pos_x=node->blank_pos_x+1;
				move[DOWN]->blank_pos_y=node->blank_pos_y;
				move[DOWN]->last_move=DOWN;
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x+1, node->blank_pos_y);
				node_generated=node_generated+1;
				
			}
			else if(movement==RIGHT){
				//move right
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x, node->blank_pos_y+1);
				copy(move[RIGHT]->s, node->s);
				move[RIGHT]->blank_pos_x=node->blank_pos_x;
				move[RIGHT]->blank_pos_y=node->blank_pos_y+1;
				move[RIGHT]->last_move=RIGHT;
				swap(node->s, node->blank_pos_x, node->blank_pos_y, 
					node->blank_pos_x, node->blank_pos_y+1);
				node_generated=node_generated+1;
				
			} 
		}
	}
}
/* This is the ida search function
It takes a search node that contains the original state of a puzzle, 
the current threshold B and the next threshold B_dash. 
THreshold in this case should be the depth of the search.

This function apply iterative deepening A* heuristic search rules. 
*/
search_node* IDA_S(search_node* node, int* B, int* B_dash){
	/*define the next generation of search nodes, (assign them with memmory)*/
	search_node next_node_0;//each of the node representing one possible movement
	search_node next_node_1;//of the blank block in the puzzle
	search_node next_node_2;
	search_node next_node_3;
	/*create the move array, fill them with pointer to the possible movement
	nodes*/
	search_node* move[4]={&next_node_0, &next_node_1, &next_node_2, &next_node_3};
	search_node* r;//this is pointer of the result of this search
	
	generate_move(node, move);//generate the possible moves, and fill the array
	int i;
	for(i=0;i<=ITERATOR;i++){//for each of the possible movement(action)
		if(move[i] != NULL){//if the action(movement) is actually applied
			move[i]->g = 1 + node->g;//update the cost from the initial state
			//to this node
			move[i]->f=move[i]->g + heuristic(move[i]->s);//update the
			//evaluation function(in wida case, the hueristic is times
			//by the factor of 1.5 to push the boundary futher).

			/*This is the first situation, the evaluation
			value is bigger than the current threshold, 
			need to expand the bound*/
			if(move[i]->f>*B){
				*B_dash=min(move[i]->f, *B_dash);//the next boundary is pushed
				//futher
			}
			else{	
				/*if the heuristic(Manhatton distance of all the tiles) is 0,
				that means the puzzle is solved*/
				if(heuristic(move[i]->s)==0){
					return move[i];//this is the solution
				}
				/*The other situation, f is less than the boundary, 
				continue expanding by iterating, and generating more nodes*/
				node_expanded++;//this is the counter for how much nodes got expanded
				r=IDA_S(move[i], B, B_dash);
				/*the base case, all the work has been done, return the result
				for this level of expansion*/
				if(r!=NULL){
					return r;
				}
			}
		}
	}
	
	return NULL;
}
/*this function handle the standard input and 
return the puzzle from standard input, store it in matrix s0, and store the blank
position inside the node*/
void read_puzzle(search_node* node, int s0[PUZZLELEN][PUZZLEWID]){
	int input_col, input_row;
	for(input_row=0;input_row<=ITERATOR;input_row++){
		for(input_col=0;input_col<=ITERATOR;input_col++){
			int next;
			scanf("%d", &next);
			if(next==0){
				node->blank_pos_x=input_row;
				node->blank_pos_y=input_col;
				s0[input_row][input_col]=next;
			}
			else{
				s0[input_row][input_col]=next;
			}
		}
	}
}

search_node current_node;
/*the control loop of the ida star search function is stored in the main*/
int
main(int argc, char* argv[]){
	/*start the timer*/
	clock_t begin, end;
	double time_spent;
	begin = clock();
	
	/*initilising the node*/
	search_node* node;//pointer a node
	node = &current_node;//point it to the node i created, current node
	search_node* r=NULL;  //this is the final node
	
	//initilise the 2D array for storing the initial state
	int s0[PUZZLEWID][PUZZLELEN];
	
	//read from standard input
	read_puzzle(node, s0);

	printf("Initial state:\n");
	print(s0);		

	//Initilise the boundary	
	int B= heuristic(s0);
	printf("Initial Estimate = %d\n", B);
	printf("Threshold = %d", B);
	int B_dash;
	//initilise the node
	node->g=0;
	node->f=0;
	node->last_move=INVALID_MOVE;

	/*The ida* controll loop*/
	while (r == NULL){		//while there's still no result																																					
		B_dash=INT_MAX/2;//initilise the next boundary to infinity, /2 is used
		//to prevent integer overflow
		copy(node->s, s0);
		node->g=0;
		r = IDA_S(node, &B, &B_dash);//use ida to search for result
		if(r==NULL){
			B=B_dash;//update the boundary
			printf(" %d", B);
		}
	}

	/*printing the result to std out in format and stop timming*/
	printf("\nSolution = %d\n", B);
	printf("Generated = %ld\nExpanded = %ld\n"
		, node_generated, node_expanded);
	end = clock();
	time_spent = (double) (end-begin) / CLOCKS_PER_SEC;
	printf("Time = %f\n", time_spent);
	printf("Expanded/Second = %d\n", (int)(node_expanded/time_spent));
	//print(r->s);
	return 0;
}


