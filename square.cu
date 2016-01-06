#include <stdio.h>

__global__ void square(float * d_out, float *d_in)
{
  int idx = threadIdx.x;
  float f = d_in[idx];
  d_out[idx] = f;
}

int main (int argc, char ** argv)
{
  const int ARRAY_SIZE = 64;
  const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

  //generate input array on host
  float h_in[ARRAY_SIZE];
  for (int i = 0; i< ARRAY_SIZE; i++)
  {
    h_in[i] = float(i);
    printf("%f\n", h_in[i]);
  }

  float h_out[ARRAY_SIZE];

  //declare gpu memory pointers
  //just like cpu pointers
  float *d_in;
  float *d_out;

  //allocate gpu memory
  cudaMalloc((void **) &d_in, ARRAY_BYTES);
  cudaMalloc((void **) &d_out, ARRAY_BYTES);

  //transfer array to device)
  cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);


  square<<<1, ARRAY_SIZE>>>(d_out, d_in); //cuda launch operator <<< >>>
  //launch one block on 64 threads (64 elements in array, 1:1



  cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);


  for (int i =0; i<ARRAY_SIZE; i++)
  {
    printf("%f", h_out[i]);
    //okay this is a badass trick
    printf(((i % 4) != 3) ? "\t" : "\n");
    // printf(((i % 11) != 10) ? "\t" : "\n");
  }

  cudaFree(d_in);
  cudaFree(d_out);

  return 0;
}
