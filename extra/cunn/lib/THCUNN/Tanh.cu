#include "THCUNN.h"

struct tanhupdateOutput_functor
{
  __device__ void operator()(float *output, const float *input) const
  {
    *output = tanh(*input);
  }
};

void THNN_CudaTanh_updateOutput(THCState *state, THCudaTensor *input, THCudaTensor *output)
{
  THAssert(THCudaTensor_checkGPU(state, 2, input, output));
  THCudaTensor_resizeAs(state, output, input);
  THCudaTensor_pointwiseApply2(state, output, input, tanhupdateOutput_functor());
}

struct tanhupdateGradInput_functor
{
  __device__ void operator()(float *gradInput, const float *output, const float *gradOutput) const
  {
    *gradInput = *gradOutput * (1 - *output * *output);
  }
};

void THNN_CudaTanh_updateGradInput(THCState *state, THCudaTensor *input, THCudaTensor *gradOutput, THCudaTensor *gradInput, THCudaTensor *output)
{
  THAssert(THCudaTensor_checkGPU(state, 3, output, gradOutput, gradInput));
  THCudaTensor_resizeAs(state, gradInput, output);
  THCudaTensor_pointwiseApply3(state, gradInput, output, gradOutput, tanhupdateGradInput_functor());
}
