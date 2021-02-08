name: string

#Step: {
  "continue-on-error"?: bool
  id?: string
  if?: string
  name: string
  run?: string
  uses?: string
  uses?: string
  env?: {
    [string]: string
  }
  with?: {
    [string]: string | bool
  }
}

jobs: {
  terraform:  {
    name: string
    "runs-on": string
    steps: [...#Step]
  }
}
