name: =~"^\\p{Lu}" // Must start with an uppercase letter.

#Step: {
  "continue-on-error"?: bool
  id?: string
  if?: string
  name: =~"^\\p{Lu}" // Must start with an uppercase letter.
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
    name: =~"^\\p{Lu}" // Must start with an uppercase letter.
    "runs-on": string
    steps: [...#Step]
  }
}
